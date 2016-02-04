//
//  BucketsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 27/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class BucketsProvider: Pageable, Authorizable {
    
    // Pageable protocol conformance.
    var nextPageableComponents = [PageableComponent]()
    var previousPageableComponents = [PageableComponent]()
    
    private var didDefineProviderMethodBefore = false
    
    /**
     Provides authenticated user’s buckets.
     
     **Important:** Authenticated user is required.

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
}

private extension BucketsProvider {
    
    func provideBucketsWithQueries(queries: [Query], authentizationRequired: Bool) -> Promise<[Bucket]?> {
        
        resetPages()
        didDefineProviderMethodBefore = true
        
        return Promise<[Bucket]?> { fulfill, reject in
        
            firstly {
                authorizeIfNeeded(authentizationRequired)
            }.then {
                self.firstPageForQueries(queries)
            }.then(fulfill).error(reject)
        }
    }
}
