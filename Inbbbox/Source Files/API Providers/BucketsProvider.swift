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

     - returns: Promise which resolves with buckets. Optional.
     */
    func provideMyBuckets() -> Promise<[Bucket]?> {
        
        let query = BucketQuery()
        
        return provideBucketsWithQuery(query)
    }
    
    /**
     Provides a given user’s buckets.
     
     - parameter user: User for who buckets should be provided.
     
     - returns: Promise which resolves with buckets. Optional.
     */
    func provideBucketsForUser(user: User) -> Promise<[Bucket]?> {
        
        let query = BucketQuery(user: user)
        
        return provideBucketsWithQuery(query)
    }
}

private extension BucketsProvider {
    
    func provideBucketsWithQuery(query: BucketQuery) -> Promise<[Bucket]?> {
        return Promise<[Bucket]?> { fulfill, reject in
            
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { response -> Void in
                
                let buckets = response
                    .map { $0.arrayValue.map { Bucket.map($0) } }
                
                fulfill(buckets)
                
            }.error(reject)
        }
    }
}
