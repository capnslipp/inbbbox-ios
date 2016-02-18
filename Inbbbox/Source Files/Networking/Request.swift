//
//  Request.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/**
 *  Request
 *  Requestable value type
 */
struct Request: Requestable, Responsable {
    let query: Query
    
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func resume() -> Promise<JSON?> {
        return Promise<JSON?> { fulfill, reject in
            
            do {
                try APIRateLimitKeeper.sharedKeeper.verifyRateLimit()
            } catch {
                throw error
            }
            
            let dataTask = session.dataTaskWithRequest(foundationRequest) { data, response, error in
                
                if let error = error {
                    reject(error)
                    
                } else {
                    firstly {
                        self.responseWithData(data, response: response)
                        
                    }.then { response -> Void in
                        fulfill(response.json)
                        
                    }.error(reject)
                }
            }
            
            dataTask.resume()
        }
    }
}
