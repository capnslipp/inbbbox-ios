//
//  CommentsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 10/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

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
}
