//
//  ShotDetailsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

struct CommentDisplayableData {
    
    let author: NSAttributedString
    let comment: NSAttributedString?
    let date: NSAttributedString
    let avatarURLString: String
}

final class ShotDetailsViewModel {
    
    let shot: ShotType
    private(set) var isFetchingComments = false
    
    var commentsProvider = APICommentsProvider(page: 1, pagination: 30)
    var commentsRequester = APICommentsRequester()
    var bucketsRequester = BucketsRequester()
    var shotsRequester =  ShotsRequester()
    
    var itemsCount: Int {
        
        var counter = comments.count + 1 // 1 for ShotDetailsOperationCollectionViewCell
        if hasDescription {
            counter++
        }
        
        return counter
    }
    
    private var cachedFormattedComments = [CommentDisplayableData]()
    private var comments = [CommentType]()
    private var userBucketsForShot = [BucketType]()
    private var isShotLikedByMe: Bool?
    private var userBucketsForShotCount: Int?
    
    init(shot: ShotType) {
        self.shot = shot
    }
    
    func isDescriptionIndex(index: Int) -> Bool {
        return hasDescription && index == 1
    }
    
    func isShotOperationIndex(index: Int) -> Bool {
        return index == 0
    }
    
    func isCurrentUserOwnerOfCommentAtIndex(index: Int) -> Bool {
        
        let comment = comments[indexInCommentArrayBasedOnItemIndex(index)]
        return UserStorage.currentUser?.identifier == comment.user.identifier
    }
}

// MARK: Data formatting
extension ShotDetailsViewModel {
    
    var attributedShotTitleForHeader: NSAttributedString {
        return ShotDetailsFormatter.attributedStringForHeaderFromShot(shot)
    }
    
    var attributedShotDescription: NSAttributedString? {
        return ShotDetailsFormatter.attributedShotDescriptionFromShot(shot)
    }
    
    var hasDescription: Bool {
        if let description = shot.attributedDescription where description.length > 0 {
            return true
        }
        return false
    }
    
    func displayableDataForCommentAtIndex(index: Int) -> CommentDisplayableData {
        
        let indexWithOffset = indexInCommentArrayBasedOnItemIndex(index)
        
        let existsCachedComment = cachedFormattedComments.count - 1 > indexWithOffset 
        if !existsCachedComment {
            
            let comment = comments[indexWithOffset]
            let displayableData = CommentDisplayableData(
                author: ShotDetailsFormatter.commentAuthorForComment(comment),
                comment: ShotDetailsFormatter.attributedCommentBodyForComment(comment),
                date: ShotDetailsFormatter.commentDateForComment(comment),
                avatarURLString: comment.user.avatarString ?? ""
            )
            
            cachedFormattedComments.append(displayableData)
        }
        
        return cachedFormattedComments[indexWithOffset]
    }
}

// MARK: Likes handling
extension ShotDetailsViewModel {
    
    func performLikeOperation() -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            
            let like = !isShotLikedByMe!
            
            firstly {
                like ? shotsRequester.likeShot(shot) : shotsRequester.unlikeShot(shot)
            }.then { _ -> Void in
                self.isShotLikedByMe = like
                fulfill(like)
            }.error(reject)
        }
    }
    
    func checkLikeStatusOfShot() -> Promise<Bool> {
        
        if let isShotLikedByMe = isShotLikedByMe {
            return Promise(isShotLikedByMe)
        }
        
        return Promise<Bool> { fulfill, reject in
            
            firstly {
                shotsRequester.isShotLikedByMe(shot)
            }.then { isShotLikedByMe -> Void in
                self.isShotLikedByMe = isShotLikedByMe
                fulfill(isShotLikedByMe)
            }.error(reject)
        }
    }
}

// MARK: Buckets handling
extension ShotDetailsViewModel {
    
    func checkShotAffiliationToUserBuckets() -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in

            firstly {
                checkNumberOfUserBucketsForShot()
            }.then { number -> Void in
                fulfill(Bool(number))
            }.error(reject)
        }
    }
    
    func checkNumberOfUserBucketsForShot() -> Promise<Int> {
        
        if let userBucketsForShotCount = userBucketsForShotCount {
            return Promise(userBucketsForShotCount)
        }
        
        return Promise<Int> { fulfill, reject in
            
            firstly {
                shotsRequester.userBucketsForShot(shot)
            }.then { buckets -> Void in
                self.userBucketsForShot = buckets
                self.userBucketsForShotCount = self.userBucketsForShot.count
                fulfill(self.userBucketsForShotCount!)
            }.error(reject)
        }
    }
    
    func clearBucketsData() {
        userBucketsForShotCount = nil
        userBucketsForShot = []
    }
    
    func removeShotFromBucketIfExistsInExactlyOneBucket() -> Promise<(removed: Bool, bucketsNumber: Int?)> {
        return Promise<(removed: Bool, bucketsNumber: Int?)> { fulfill, reject in
            
            var numberOfBuckets: Int?
            
            firstly {
                checkNumberOfUserBucketsForShot()
            }.then { number -> Void in
                numberOfBuckets = number
                if numberOfBuckets == 1 {
                    self.bucketsRequester.removeShot(self.shot, fromBucket: self.userBucketsForShot[0])
                }
            }.then { () -> Void in
                if numberOfBuckets == 1 {
                    self.clearBucketsData()
                    fulfill((removed: true, bucketsNumber: nil))
                } else {
                    fulfill((removed: false, bucketsNumber: numberOfBuckets))
                }
            }.error(reject)
        }
    }
}

// MARK: Comments handling
extension ShotDetailsViewModel {
    
    var isCommentingAvailable: Bool {
        if let accountType = UserStorage.currentUser?.accountType {
            return accountType == .Player || accountType == .Team
        }
        return  false
    }
    
    var hasMoreCommentsToFetch: Bool {
        return UInt(comments.count) < shot.commentsCount
    }
    
    var commentsCount: Int {
        return comments.count
    }
    
    func loadComments() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            isFetchingComments = true

            if comments.count == 0 {
                firstly {
                    commentsProvider.provideCommentsForShot(shot)
                }.then { comments -> Void in
                    self.comments = comments ?? []
                }.always {
                    self.isFetchingComments = false
                }.then(fulfill).error(reject)
                
            } else {
                
                firstly {
                    commentsProvider.nextPage()
                }.then { comments -> Void in
                    if let comments = comments {
                        self.comments.appendContentsOf(comments)
                    }
                }.always {
                    self.isFetchingComments = false
                }.then(fulfill).error(reject)
            }
        }
    }
    
    func loadAllComments() -> Promise<Void> {
        
        if comments.count >= Int(shot.commentsCount) {
            return Promise()
        }
        
        return Promise<Void> { fulfill, reject in
         
            firstly {
                loadComments()
            }.then {
                if !self.hasMoreCommentsToFetch {
                    fulfill()
                }
                return self.loadAllComments()
            }.then(fulfill).error(reject)
        }
    }
    
    func postComment(message: String) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            firstly {
                commentsRequester.postCommentForShot(shot, withText: message)
            }.then { comment in
                self.comments.append(comment)
            }.then(fulfill).error(reject)
        }
    }
    
    func deleteCommentAtIndex(index: Int) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            let comment = comments[indexInCommentArrayBasedOnItemIndex(index)]
            
            firstly {
                commentsRequester.deleteComment(comment, forShot: shot)
            }.then { comment in
                self.comments.removeAtIndex(self.indexInCommentArrayBasedOnItemIndex(index))
            }.then { _ in
                fulfill()
            }.error(reject)
        }
    }
}

private extension ShotDetailsViewModel {
    
    func indexInCommentArrayBasedOnItemIndex(index: Int) -> Int {
        return comments.count - itemsCount + index
    }
}
