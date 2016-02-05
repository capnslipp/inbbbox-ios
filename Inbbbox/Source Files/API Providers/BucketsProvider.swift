//
//  BucketsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 27/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class BucketsProvider: PageableProvider, Authorizable {
        
    /**
     Provides authenticated user’s buckets.
     
     - Requires: Authenticated user.

     - returns: Promise which resolves with buckets or nil.
     */
    func provideMyBuckets() -> Promise<[Bucket]?> {
        
        let query = BucketQuery()
        return provideBucketsWithQueries([query], authentizationRequired: true)
    }
    
    /**
     Provides a given user’s buckets.
     
     - parameter user: User for who buckets should be provided.
     
     - returns: Promise which resolves with buckets or nil.
     */
    func provideBucketsForUser(user: User) -> Promise<[Bucket]?> {
        return provideBucketsForUsers([user])
    }
    
    /**
     Provides a given users' buckets.
     
     - parameter users: Array of users for whose buckets should be provided.
     
     - returns: Promise which resolves with buckets or nil.
     */
    func provideBucketsForUsers(users: [User]) -> Promise<[Bucket]?> {
        
        let queries = users.map { BucketQuery(user: $0) } as [Query]
        return provideBucketsWithQueries(queries, authentizationRequired: false)
    }
    
    /**
     Provides next page of buckets.
     
     - Warning: You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with buckets or nil.
     */
    func nextPage() -> Promise<[Bucket]?> {
        return nextPageFor(Bucket)
    }
    
    /**
     Provides previous page of buckets.
     
     - Warning: You have to use any of provide... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with buckets or nil.
     */
    func previousPage() -> Promise<[Bucket]?> {
        return previousPageFor(Bucket)
    }
}

private extension BucketsProvider {
    
    func provideBucketsWithQueries(queries: [Query], authentizationRequired: Bool) -> Promise<[Bucket]?> {
        return Promise<[Bucket]?> { fulfill, reject in
        
            firstly {
                authorizeIfNeeded(authentizationRequired)
            }.then {
                self.firstPageForQueries(queries)
            }.then(fulfill).error(reject)
        }
    }
}
