//
//  Requestable.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

/// Defines how Requestable type should behave
protocol Requestable {
    var query: Query { get }
    var foundationRequest: NSURLRequest { get }
}

// MARK: - Common implementation for Requestable
extension Requestable {
    
    /// Foundation request based on query.
    var foundationRequest: NSURLRequest {
        
        let queryItems = query.parameters.queryItems
                
        let components = NSURLComponents()
        components.scheme = query.service.scheme
        components.host = query.service.host
        components.path = query.service.version + query.path
        
        if queryItems.count > 0 {
            components.queryItems = queryItems
        }
        
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
}
