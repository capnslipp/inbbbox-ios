//
//  ShotOperationRequester.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

final class ShotOperationRequester {
    
    class func likeShot(shotID: Int) -> Promise<Void> {
        
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
    
    class func unlikeShot(shotID: Int) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = UnlikeQuery(shotID: shotID.stringValue)
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
    
    class func addToBucket(shotID: Int, bucketID: Int) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = AddToBucketQuery(shotID: shotID, bucketID: bucketID)
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
    
    class func removeFromBucket(shotID: Int, bucketID: Int) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let query = RemoveFromBucketQuery(shotID: shotID, bucketID: bucketID)
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
}
