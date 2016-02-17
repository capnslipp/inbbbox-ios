//
//  ShotsRequester.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

/// Provides interface for dribbble shots update, delete and create API
class ShotsRequester: Verifiable {

    /**
     Likes given shot.
     
     - Requires: Authenticated user.
     
     - parameter shot: Shot to like.
     
     - returns: Promise which resolves with void.
     */
    func likeShot(shot: Shot) -> Promise<Void> {
        
        let query = LikeQuery(shot: shot)
        return sendShotQuery(query)
    }
    
    /**
     Unlikes given shot.
     
     - Requires: Authenticated user.
     - Warning:  Authenticated user has to previously like the shot.
     
     - parameter shot: Shot to unlike.
     
     - returns: Promise which resolves with void.
     */
    func unlikeShot(shot: Shot) -> Promise<Void> {
        
        let query = UnlikeQuery(shot: shot)
        return sendShotQuery(query)
    }
    
    /**
     Checks whether shot is liked by authenticated user or not.
     
     - Requires: Authenticated user.
     
     - parameter shot: Shot to check.
     
     - returns: Promise which resolves with true (if user likes shot) or false (if don't)
     */
    func isShotLikedByMe(shot: Shot) -> Promise<Bool> {
        
        return Promise<Bool> { fulfill, reject in
            
            let query = ShotLikedByMeQuery(shot: shot)

            firstly {
                sendShotQuery(query)
            }.then { _ in
                fulfill(true)
            }.error { error in
                // According to API documentation, when response.code is 404,
                // then shot is not liked by authenticated user.
                (error as NSError).code == 404 ? fulfill(false) : reject(error)
            }
        }
    }
}

private extension ShotsRequester {
    
    func sendShotQuery(query: Query) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            firstly {
                verifyAuthenticationStatus(true)
            }.then {
                Request(query: query).resume()
            }.then { _ -> Void in
                fulfill()
            }.error(reject)
        }
    }
}
