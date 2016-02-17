//
//  ConnectionsRequester.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

/// Provides interface for dribbble followers and followees update, delete, create API
final class ConnectionsRequester: Verifiable {
    
    /**
     Adds authenticated user to given user followers.
     
     - Requires: Authenticated user.
     - Note:     Following errors may occur:
         - You cannot follow yourself.
         - You have been blocked from following this member at their request.
         - You have reached the maximum number of follows allowed.
     
     - parameter user:   User to follow.
     
     - returns: Promise which resolves with void.
     */
    func followUser(user: User) -> Promise<Void> {
        
        let query = FollowUserQuery(user: user)
        return sendConnectionQuery(query)
    }
    
    /**
     Removes authenticated user to given user followers.
     
     - Requires: Authenticated user.
     - Warning:  Authenticated user has to follow given user first.
     
     - parameter user:   User to unfollow.
     
     - returns: Promise which resolves with void.
     */
    func unfollowUser(user: User) -> Promise<Void> {
        
        let query = UnfollowUserQuery(user: user)
        return sendConnectionQuery(query)
    }
}

private extension ConnectionsRequester {
    
    func sendConnectionQuery(query: Query) -> Promise<Void> {
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
