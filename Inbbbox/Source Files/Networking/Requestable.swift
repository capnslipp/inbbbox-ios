//
//  Requestable.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Async

let NetworkErrorDomain = "co.netguru.inbbbox.error.network"

/**
 *  Requestable
 *  Defines how Requestable type should behave
 */
protocol Requestable {
    var query: Query { get }
    var foundationRequest: NSURLRequest { get }
}

// MARK: - Common implementation for Requestable
extension Requestable {
    
    var foundationRequest: NSURLRequest {
        
        let queryItems = query.parameters.queryItems
                
        let components = NSURLComponents()
        components.scheme = query.service.scheme
        components.host = query.service.host
        components.path = query.service.version + query.path
        components.queryItems = queryItems
        
        // Intentionally force unwrapping optional to get crash when problem occur
        let mutableRequest = NSMutableURLRequest(URL: components.URL!)
        mutableRequest.HTTPMethod = query.method.rawValue
        mutableRequest.HTTPBody = query.parameters.body
        
        if mutableRequest.HTTPBody != nil {
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        query.service.authorizeRequest(mutableRequest)
        
        return mutableRequest.copy() as! NSURLRequest
    }
    
    func resume() -> Promise<JSON?> {

        let promise = Promise<JSON?> { fulfill, reject in
            let dataTask = self.session.dataTaskWithRequest(self.foundationRequest) { data, response, error in
                
                if let error = self.checkResponseForError(response, withError: error) {
                    reject(error)
                    return
                }
                
                if let responseData = data where data?.length>0 {
                    var swiftyJSON: JSON? = nil
                    var serializationError: NSError?
                    
                    Async.background {
                        swiftyJSON = JSON(data: responseData, options: .AllowFragments, error: &serializationError)
                    }.main {
                        if let serializationError = serializationError {
                            reject(serializationError)
                        } else {
                            fulfill(swiftyJSON)
                        }
                    }
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 204 {
                    fulfill(nil)
                } else {
                    let message = NSLocalizedString("Failed retrieving data", comment: "")
                    let otherError = NSError(domain: NetworkErrorDomain, code: 0, message: message)
                    reject(otherError)
                }
            }
            
            dataTask.resume()
        }
        
        return promise
    }
}

// MARK: - Private extension of Requestable
extension Requestable {
    
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func checkResponseForError(response: NSURLResponse?, withError error: NSError?) -> NSError? {
        if let response = response as? NSHTTPURLResponse where response.statusCode >= 400 {
            let message: String = {
                if response.statusCode == 401 {
                    return NSLocalizedString("Authorization expired. Please log in again.", comment: "")
                }
                return NSLocalizedString("Failed retrieving data", comment: "")
            }()
            return NSError(domain: NetworkErrorDomain, code: response.statusCode, message: message)
        }
        return error
    }
}
