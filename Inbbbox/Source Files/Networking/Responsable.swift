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

/**
 *  Responsable
 *  Defines how Responsable type should behave.
 */

typealias Response = (json: JSON?, header: [String: AnyObject]?)

protocol Responsable {
    func responseWithData(data: NSData?, response: NSURLResponse?) -> Promise<Response>
}

extension Responsable {
    
    func responseWithData(data: NSData?, response: NSURLResponse?) -> Promise<Response> {
        
        return Promise<Response> { fulfill, reject in
            
            let header = (response as? NSHTTPURLResponse)?.allHeaderFields as? [String: AnyObject]
            
            if let error = self.checkResponseForError(response) {
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
