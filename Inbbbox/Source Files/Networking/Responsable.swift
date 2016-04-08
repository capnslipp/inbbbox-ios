//
//  Responsable.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit
import Async

let NetworkErrorDomain = "co.netguru.inbbbox.error.network"

enum ResponseError: ErrorType {
    case UnexpectedResponse
}

typealias Response = (json: JSON?, header: [String: AnyObject]?)


/// Defines how Responsable type should behave.
protocol Responsable {
    
    /// Convert response data to `Response` object that may contain JSON and header
    /// 
    /// - parameter data:     Data to convert.
    /// - parameter response: `NSURLResponse` received from server
    /// 
    /// - returns: Promise which resolves with `Response`
    func responseWithData(data: NSData?, response: NSURLResponse?) -> Promise<Response>
}

extension Responsable {
    
    func responseWithData(data: NSData?, response: NSURLResponse?) -> Promise<Response> {
        
        return Promise<Response> { fulfill, reject in
            
            do {
                try APIRateLimitKeeper.sharedKeeper.verifyResponseForRateLimitation(response)
            } catch {
                throw error
            }
            
            let header = (response as? NSHTTPURLResponse)?.allHeaderFields as? [String: AnyObject]
            
            APIRateLimitKeeper.sharedKeeper.setCurrentLimitFromHeader(header ?? [:])
            
            if let error = self.checkDataForError(data, response: response) {
                throw error
            } else if let error = self.checkResponseForError(response) {
                throw error
            } else if let responseData = data where data?.length > 0 {
                
                var swiftyJSON: JSON? = nil
                var serializationError: NSError?
                
                Async.background {
                    swiftyJSON = JSON(data: responseData, options: .AllowFragments, error: &serializationError)
                }.main {
                    if let serializationError = serializationError {
                        reject(serializationError)
                    } else {
                        fulfill((json: swiftyJSON, header: header))
                    }
                }
                
            } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 204 {
                fulfill((json: nil, header: header))
            } else {
                let message = NSLocalizedString("Failed retrieving data", comment: "")
                throw NSError(domain: NetworkErrorDomain, code: 0, message: message)
            }
        }
    }
}


// MARK: - Private extension of Responsable
private extension Responsable {
    
    func checkDataForError(data: NSData?, response: NSURLResponse?) -> NSError? {
        
        guard let response = response as? NSHTTPURLResponse where response.statusCode >= 400 else {
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        let swiftyJSON = JSON(data: data, options: .AllowFragments, error: nil)
        guard let message = swiftyJSON["errors"].array?.first?["message"].string else {
            return nil
        }
        
        return NSError(domain: NetworkErrorDomain, code: response.statusCode, message: message)
    }
    
    func checkResponseForError(response: NSURLResponse?) -> NSError? {
        
        guard let response = response as? NSHTTPURLResponse where response.statusCode >= 400 else {
            return nil
        }
        
        let message: String = {
            if response.statusCode == 401 {
                return NSLocalizedString("Authorization expired. Please log in again.", comment: "")
            }
            return NSLocalizedString("Failed retrieving data", comment: "")
        }()
        return NSError(domain: NetworkErrorDomain, code: response.statusCode, message: message)
    }
}
