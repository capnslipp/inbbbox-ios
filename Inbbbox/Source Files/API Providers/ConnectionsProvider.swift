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
class ConnectionsProvider: Pageable, Authorizable {
    
    // Pageable protocol conformance.
    var nextPageableComponents = [PageableComponent]()
    var previousPageableComponents = [PageableComponent]()
    
    private var didDefineProviderMethodBefore = false
    
    /**
     Provides a list the authenticated user’s followers.
     
     **Important:** Authenticated user is required.
     
     - returns: Promise which resolves with followers or nil.
     */
    func provideMyFollowers() -> Promise<[Follower]?> {
        
        let query = FollowersQuery()
        return provideUsersWithQueries([query], authentizationRequired: true)
    }
    
    /**
    Provides a list who the authenticated user is following.
     
    **Important:** Authenticated user is required.
    
    - returns: Promise which resolves with followees or nil.
    */
    func provideMyFollowees() -> Promise<[Followee]?> {
    
        let query = FolloweesQuery()
        return provideUsersWithQueries([query], authentizationRequired: true)
    }
    
    /**
     Provides a given user’s followers list.
     
     - parameter user: User for who followers list should be provided.
     
     - returns: Promise which resolves with followers or nil.
     */
    func provideFollowersForUser(user: User) -> Promise<[Follower]?> {
        return provideFollowersForUsers([user])
    }
    
    /**
     Provides a given users' followers list.
     
     - parameter users: Users for whose followers list should be provided.
     
     - returns: Promise which resolves with followers or nil.
     */
    func provideFollowersForUsers(users: [User]) -> Promise<[Follower]?> {
        
        let queries = users.map { FollowersQuery(followersOfUser: $0) } as [Query]
        return provideUsersWithQueries(queries, authentizationRequired: false)
    }
    
    /**
     Provides a list who given user is following.
     
     - parameter user: User for who followees list should be provided.
     
     - returns: Promise which resolves with followees or nil.
     */
    func provideFolloweesForUser(user: User) -> Promise<[Followee]?> {
        return provideFolloweesForUsers([user])
    }
    
    /**
     Provides a list who given users are following.
     
     - parameter users: Users for whose followees list should be provided.
     
     - returns: Promise which resolves with followees or nil.
     */
    func provideFolloweesForUsers(users: [User]) -> Promise<[Followee]?> {
        
        let queries = users.map { FolloweesQuery(followeesOfUser: $0) } as [Query]
        return provideUsersWithQueries(queries, authentizationRequired: false)
    }
    
    /**
     Provides next page of followees / followers.
     
     **Important** You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with shots or nil.
     */
    func nextPage() -> Promise<[User]?> {
        return fetchPage(nextPageFor(Connection))
    }
    
    /**
     Provides previous page of followees / followers.
     
     **Important** You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with shots or nil.
     */
    func previousPage() -> Promise<[User]?> {
        return fetchPage(previousPageFor(Connection))
    }
}

private extension ConnectionsProvider {
    
    func provideUsersWithQueries(queries: [Query], authentizationRequired: Bool) -> Promise<[User]?> {
        
        resetPages()
        didDefineProviderMethodBefore = true
        
        return Promise<[User]?> { fulfill, reject in
            
            firstly {
                authorizeIfNeeded(authentizationRequired)
            }.then {
                self.firstPageFor(Connection.self, withQueries: queries)
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }
    
    func fetchPage(promise: Promise<[Connection]?>) -> Promise<[User]?> {
        return Promise<[User]?> { fulfill, reject in
            
            if !didDefineProviderMethodBefore {
                throw PageableError.PageableBehaviourUndefined
            }
            
            firstly {
                promise
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }
    
    func serialize(connections: [Connection]?, _ fulfill: ([User]?) -> Void) {
        fulfill( connections?.map { $0.user }.flatMap { $0 } )
    }
}
