//
//  CommentsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 10/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/// Provides interface for dribbble comments API
class CommentsProvider: PageableProvider {

    /**
     Provides comments for given shot.
     
     - parameter shot: Shot which comments should be fetched
     
     - returns: Promise which resolves with comments or nil.
     */
    func provideCommentsForShot(shot: Shot) -> Promise<[Comment]?> {
        
        let query = CommentQuery(shot: shot)
        return self.firstPageForQueries([query], withSerializationKey: nil)
    }
    
    
    /**
     Provides next page of comments.
     
     - Warning: You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with comments or nil.
     */
    func nextPage() -> Promise<[Comment]?> {
        return nextPageFor(Comment)
    }
    
    /**
     Provides previous page of comments.
     
     - Warning: You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with comments or nil.
     */
    func previousPage() -> Promise<[Comment]?> {
        return previousPageFor(Comment)
    }
    
    /**
     Creates and posts comment for given shot with provided text.
     
     - Warning: Posting comments requires authenticated user with AccountType *Team* or *Player*
     
     - parameter shot: Shot which should be commented.
     - parameter text: Text of comment.
     
     - returns: Promise which resolves with created comment or nil (if server did response with empty json).
     */
    func postCommentForShot(shot: Shot, withText text: String) -> Promise<Comment?> {
        
        let query = CreateCommentQuery(shot: shot, body: text)
        return sendCommentQuery(query, verifyTextLength: text)
    }
    
    /**
     Updates given comment for shot with provided text.
     
     - Warning: Updating comments requires authenticated user with AccountType *Team* or *Player*.
     User has to be owner of comment.
     
     - parameter comment: Comment which should be updated.
     - parameter shot:    Shot which belongs to comment.
     - parameter text:    New body of comment.
     
     - returns: Promise which resolves with updated comment or nil (if server did response with empty json).
     */
    func updateComment(comment: Comment, forShot shot: Shot, withText text: String) -> Promise<Comment?>  {
        
        let query = UpdateCommentQuery(shot: shot, comment: comment, withBody: text)
        return sendCommentQuery(query, verifyTextLength: text)
    }
    
    /**
     Deletes given comment for provided shot.
     
     - Warning: Deleting comments requires authenticated user with AccountType *Team* or *Player*.
     User has to be owner of comment.
     
     - parameter comment: Comment which should be deleted.
     - parameter shot:    Shot which belongs to comment.
     
     - returns: Promise which resolves with Void.
     */
    func deleteComment(comment: Comment, forShot shot: Shot) -> Promise<Void>  {
        return Promise<Void> { fulfill, reject in
            
            let query = DeleteCommentQuery(shot: shot, comment: comment)
            
            firstly {
                sendCommentQuery(query)
            }.then { _ in fulfill() }.error(reject)
        }
    }
}

private extension CommentsProvider {
    
    func sendCommentQuery(query: Query, verifyTextLength text: String) -> Promise<Comment?> {
        return Promise<Comment?> { fulfill, reject in
            
            firstly {
                verifyTextLength(text, min: 1, max: UInt.max)
            }.then {
                self.sendCommentQuery(query)
            }.then(fulfill).error(reject)
        }
    }
    
    func sendCommentQuery(query: Query) -> Promise<Comment?> {
        return Promise<Comment?> { fulfill, reject in
            
            firstly {
                verifyAuthenticationStatus(true)
            }.then {
                self.verifyAccountType()
            }.then {
                 Request(query: query).resume()
            }.then { json -> Void in
                
                if let json = json {
                    fulfill(Comment.map(json))
                } else {
                    fulfill(nil)
                }
                
            }.error(reject)
        }
    }
}
