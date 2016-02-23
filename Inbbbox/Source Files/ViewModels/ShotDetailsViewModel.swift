//
//  ShotDetailsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit.NSAttributedString

final class ShotDetailsViewModel {
    
    var commentsCount: Int {
        return comments.count
    }
    
    var itemsCount: Int {
        
        var counter = Int(1) //for ShotDetailsOperationCollectionViewCell
        if let description = shot.description where description.string.characters.count > 0 {
            counter++
        }
        if hasCommentsToFetch {
            counter += comments.count
        }
        
        return counter
    }
    
    // requesters and provider
    var commentsProvider = CommentsProvider(page: 1, pagination: 20)
    var commentsRequester = CommentsRequester()
    
    private let localStorage = ShotsLocalStorage()
    private let userStorageClass = UserStorage.self
    private let shotsRequester =  ShotsRequester()
    
    let shot: Shot
    private(set) var comments = [Comment]()
    
    // Private
    private var hasCommentsToFetch: Bool {
        return shot.commentsCount != 0
    }
    
    var attributedShotTitleForHeader: NSAttributedString {
        return ShotDetailsFormatter.attributedStringForHeaderFromShot(shot)
    }
    
    var attributedShotDescription: NSAttributedString? {
        return ShotDetailsFormatter.attributedShotDescriptionFromShot(shot)
    }
    
    init(shot: Shot) {
        self.shot = shot
    }
    
    func isDescriptionIndex(index: Int) -> Bool {
        if index > 1 {
            return false
        } else if let description = shot.description where description.string.characters.count > 0 {
            return true
        }
        return false
    }
    
    func isShotOperationIndex(index: Int) -> Bool {
        return index == 0
    }
    
    // Comments methods
    
    func loadComments() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            if comments.count == 0 {
                firstly {
                    commentsProvider.provideCommentsForShot(shot)
                }.then { comments -> Void in
                    self.comments = comments ?? []
                }.then(fulfill).error(reject)
                
            } else {
                
                firstly {
                    commentsProvider.nextPage()
                }.then { comments -> Void in
                    if let comments = comments {
                        self.appendCommentsAndUpdateCollectionView(comments)
                    }
                }.then(fulfill).error(reject)
            }
        }
    }
    
    //NGRToDo: Handle reloading messages appropriately
    func postComment(message: String) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            firstly {
                commentsRequester.postCommentForShot(shot, withText: message)
            }.then { comment in
                self.comments.append(comment)
            }.then(fulfill).error(reject)
        }
    }
    
    // Shot methods
    
    func userDidTapLikeButton(like: Bool, completion: (Result) -> Void) {
        
        let operationClosure = {
            if self.userStorageClass.currentUser != nil {
                firstly {
                    like ? self.shotsRequester.likeShot(self.shot) : self.shotsRequester.unlikeShot(self.shot)
                }.then {
                    completion(Result.Success)
                }.error { error in
                    completion(Result.Error(error))
                }
            } else {
                do {
                    like ? try self.localStorage.like(shotID: self.shot.identifier) : try self.localStorage.unlike(shotID: self.shot.identifier)
                    completion(Result.Success)
                } catch {
                    completion(Result.Error(error))
                }
            }
        }

        if like {
            operationClosure()
        } else {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { _ in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let unlikeAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Unlike", comment: ""), style: .Destructive) { _ in
                operationClosure()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(unlikeAction)
            //NGRTemp: backward compatibility
//            delegate?.presentAlertController(alertController)
        }
    }
    
    func displayableDataForCommentAtIndex(index: Int) -> (author: String, comment: NSAttributedString?, date: String, avatarURLString: String) {
        
        let indexWithOffset = comments.count - itemsCount + index
        let comment = comments[indexWithOffset]

        return (
            author: comment.user.name ?? comment.user.username,
            comment: ShotDetailsFormatter.attributedCommentBodyForComment(comment),
            date: ShotDetailsFormatter.commentDateForComment(comment),
            avatarURLString: comment.user.avatarString ?? ""
        )
    }
    
    func viewDataForLoadMoreCell() -> ShotDetailsViewModel.LoadMoreCellViewData {
        let difference = Int(shot.commentsCount) - commentsCount
        return LoadMoreCellViewData(
            commentsCount: difference > Int(commentsProvider.pagination) ? Int(commentsProvider.pagination).stringValue : difference.stringValue
        )
    }
}

private extension ShotDetailsViewModel {
    
    // Comments methods
    func appendCommentsAndUpdateCollectionView(comments: [Comment]) {
        
        let currentCommentCount = self.comments.count
        let possibleLoadMoreCellIndexPath:NSIndexPath? =  {
            if commentsCount < itemsCount {
                return NSIndexPath(forItem: currentCommentCount, inSection: 0)
            } else {
                return nil
            }
        }()
        
        var indexPathsToInsert = [NSIndexPath]()
        var indexPathsToReload = [NSIndexPath]()
        var indexPathsToDelete = [NSIndexPath]()
        
        self.comments.appendContentsOf(comments)
        
        for i in currentCommentCount..<self.comments.count {
            indexPathsToInsert.append(NSIndexPath(forItem: i, inSection: 0))
        }
        if let loadMoreCellIndexPath = possibleLoadMoreCellIndexPath {
            if self.comments.count < Int(shot.commentsCount) {
                indexPathsToReload.append(loadMoreCellIndexPath)
            } else {
                indexPathsToDelete.append(loadMoreCellIndexPath)
            }
        }
        
        //NGRTemp: backward compatibility
//        delegate?.performBatchUpdate(indexPathsToInsert, reloadIndexPaths: indexPathsToReload, deleteIndexPaths: indexPathsToDelete)
    }
    
    // Shot methods
    func isShotLikedByMe() -> Promise<Bool> {
    
        return Promise<Bool> { fulfill, reject in
            
            if self.userStorageClass.currentUser != nil {
                firstly {
                    shotsRequester.isShotLikedByMe(shot)
                }.then(fulfill).error(reject)
            } else {
                let liked = localStorage.likedShots.contains {
                    $0.id == shot.identifier
                }
                fulfill(liked)
            }
        }
    }
}

extension ShotDetailsViewModel {
    
    
    struct LoadMoreCellViewData {
        let commentsCount: String
    }
}

enum Result {
    case Success
    case Error(ErrorType)
}
