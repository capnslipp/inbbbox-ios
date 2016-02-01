//
//  Provider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 27/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

enum ProviderError: ErrorType {
    case AuthenticationRequired
}

class Provider {
    
    class func sendQuery(query: Query, authenticationRequired: Bool = false) -> Promise<JSON?> {
        return Promise<JSON?> { fulfill, reject in
            
            if authenticationRequired {
                guard let _ = TokenStorage.currentToken else {
                    throw ProviderError.AuthenticationRequired
                }
            }

            let request = Request(query: query)
            request.resume().then(fulfill).error(reject)
        }
    }
    
    class func sendQueries(queries: [Query], authenticationRequired: Bool = false) -> Promise<[JSON?]> {
        return Promise<[JSON?]> { fulfill, reject in
            
            if authenticationRequired {
                guard let _ = TokenStorage.currentToken else {
                    throw ProviderError.AuthenticationRequired
                }
            }
            
            let requests = queries.map { Request(query: $0) }
            when(requests.map { $0.resume() }).then(fulfill).error(reject)
        }
    }
}
