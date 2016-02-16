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
            }.error(reject)
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
            }.error(reject)
        }
    }
    
    class func isShotLikedByMe(shot: Shot) -> Promise<Bool> {
        
        return Promise<Bool> { fulfill, reject in
            
            if let _ = UserStorage.currentUser {
                
                let query = ShotLikedByMeQuery(shot: shot)
                let request = Request(query: query)
                
                // NGRTodo: should conform Verifiable and check authentication required
                firstly {
                    request.resume()
                }.then { _ in
                    fulfill(true)
                }.error { error in
                    // According to API documentation, when response.code is 404,
                    // then shot is not liked by authenticated user.
                    (error as NSError).code == 404 ? fulfill(false) : reject(error)
                }

            } else {
                // NGRTodo: handle saving locally when user does not exist.
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
            }.error(reject)
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
            }.error(reject)
        }
    }
}
