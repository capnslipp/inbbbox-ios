//
//  BucketsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 27/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class BucketsProvider {
    
    /**
     Provides authenticated user’s buckets.
     
     **Important:** Authenticated user is required.

     - returns: Promise which resolves with buckets or nil.
     */
    func provideMyBuckets() -> Promise<[Bucket]?> {
        
        let query = BucketQuery()
        
        return provideBucketsWithQuery(query, authenticationRequired: true)
    }
    
    /**
     Provides a given user’s buckets.
     
     - parameter user: User for who buckets should be provided.
     
     - returns: Promise which resolves with buckets or nil.
     */
    func provideBucketsForUser(user: User) -> Promise<[Bucket]?> {
        
        let query = BucketQuery(user: user)
        
        return provideBucketsWithQuery(query, authenticationRequired: false)
    }
}

private extension BucketsProvider {
    
    func provideBucketsWithQuery(query: BucketQuery, authenticationRequired: Bool) -> Promise<[Bucket]?> {
        return Promise<[Bucket]?> { fulfill, reject in
        
            firstly {
                Provider.sendQuery(query, authenticationRequired: authenticationRequired)
            }.then { response -> Void in
                
                let buckets = response
                    .map { $0.arrayValue.map { Bucket.map($0) } }
                
                fulfill(buckets)
                
            }.error(reject)
        }
    }
}
