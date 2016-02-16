//
//  BucketsRequester.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/// Provides interface for dribbble buckets update, delete and create API
final class BucketsRequester: Verifiable {
    
    /**
     Adds shot to given bucket.
     
     - Requires: Authenticated user.
     - Warning: Authenticated user has to be owner of bucket.
     
     - parameter shot:   Shot which should be added to bucket.
     - parameter bucket: Bucket which should contain bucket.
     
     - returns: Promise which resolves with void.
     */
    func addShot(shot: Shot, toBucket bucket: Bucket) -> Promise<Void> {
        
        let query = AddToBucketQuery(shot: shot, bucket: bucket)
        return sendBucketQuery(query)
    }
    
    /**
     Removes shot from given bucket.
     
     - Requires: Authenticated user.
     - Warning: Authenticated user has to be owner of bucket.
     
     - parameter shot:   Shot which should be added to bucket.
     - parameter bucket: Bucket which should contain bucket.
     
     - returns: Promise which resolves with void.
     */
    func removeShot(shot: Shot, fromBucket bucket: Bucket) -> Promise<Void> {
        
        let query = RemoveFromBucketQuery(shot: shot, bucket: bucket)
        return sendBucketQuery(query)
    }
}

private extension BucketsRequester {
    
    func sendBucketQuery(query: Query) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            firstly {
                verifyAuthenticationStatus(true)
            }.then {
                self.verifyAccountType()
            }.then {
                Request(query: query).resume()
            }.then { _ -> Void in
                fulfill()
            }.error(reject)
        }
    }
}
