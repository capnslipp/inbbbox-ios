//
//  ConnectionsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

typealias Followee = User
typealias Follower = User

/// Provides connections between users, followers and followees
class ConnectionsProvider {
    
    /**
     Provides a list the authenticated user’s followers.
     
     **Important:** Authenticated user is required.
     
     - returns: Promise which resolves with followers or nil.
     */
    func provideMyFollowers() -> Promise<[Follower]?> {
        
        let query = FollowersQuery()
        return usersWithQuery(query, authenticationRequired: true)
    }
    
    /**
    Provides a list who the authenticated user is following.
     
    **Important:** Authenticated user is required.
    
    - returns: Promise which resolves with followees or nil.
    */
    func provideMyFollowees() -> Promise<[Followee]?> {
    
        let query = FolloweesQuery()
        return usersWithQuery(query, authenticationRequired: true)
    }
    
    /**
     Provides a given user’s followers list.
     
     - parameter user: User for who followers list should be provided.
     
     - returns: Promise which resolves with followers or nil.
     */
    func provideFollowersForUser(user: User) -> Promise<[Follower]?> {
    
        let query = FollowersQuery(followersOfUser: user)
        return usersWithQuery(query, authenticationRequired: false)
    }
    
    /**
     Provides a list who given user is following.
     
     - parameter user: User for who followees list should be provided.
     
     - returns: Promise which resolves with followees or nil.
     */
    func provideFolloweesForUser(user: User) -> Promise<[Followee]?> {
    
        let query = FolloweesQuery(followeesOfUser: user)
        return usersWithQuery(query, authenticationRequired: false)
    }
}

private extension ConnectionsProvider {
    
    func usersWithQuery(query: Query, authenticationRequired: Bool) -> Promise<[User]?> {
    
        return Promise<[User]?> { fulfill, reject in
        
            let serializationKey = query is FollowersQuery ? "follower" : "followee"
            
            firstly {
                Provider.sendQuery(query, authenticationRequired: authenticationRequired)
            }.then { response -> Void in
        
                let users = response
                    .map { $0.arrayValue.map { User.map($0[serializationKey]) } }

                fulfill(users)
                
            }.error(reject)
        }
    }
}
