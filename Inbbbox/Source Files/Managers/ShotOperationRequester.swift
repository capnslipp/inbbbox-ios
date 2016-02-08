//
//  ShotOperationRequester.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class ShotOperationRequester {
    
    class func likeShot(shotID: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = LikeQuery(shotID: shotID.stringValue)
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { json in
                fulfill()
            }.error { error in
                reject(error)
            }
        }
    }
    
    class func unlikeShot(shotID: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = UnlikeQuery(shotID: shotID.stringValue)
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { _ in
                fulfill()
            }.error { error in
                reject(error)
            }
        }
    }
    
    class func addToBucket(shotID: String, bucketID: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = AddToBucketQuery(shotID: shotID, bucketID: bucketID)
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { _ in
                fulfill()
            }.error { error in
                reject(error)
            }
        }
    }
    
    class func removeFromBucket(shotID: String, bucketID: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = RemoveFromBucketQuery(shotID: shotID, bucketID: bucketID)
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { _ in
                fulfill()
            }.error { error in
                reject(error)
            }
        }
    }
}
