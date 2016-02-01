//
//  Authorizable.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 01/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

enum AuthorizableError: ErrorType {
    case AuthenticationRequired
}

protocol Authorizable {
    
    func authorizeIfNeeded(authorizationRequired: Bool) -> Promise<Void>
}

extension Authorizable {
    
    func authorizeIfNeeded(authorizationRequired: Bool) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            if authorizationRequired {
                guard let _ = TokenStorage.currentToken else {
                    throw AuthorizableError.AuthenticationRequired
                }
            }
            fulfill()
        }
    }
}
