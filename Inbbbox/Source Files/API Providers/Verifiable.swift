//
//  Verifiable.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 01/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

enum VerifiableError: ErrorType {
    case AuthenticationRequired
    case WrongAccountType
}

protocol Verifiable {
    
    func verifyAuthenticationStatus(verify: Bool) -> Promise<Void>
    func verifyAccountType() -> Promise<Void>
}

extension Verifiable {
    
    func verifyAuthenticationStatus(verify: Bool) -> Promise<Void> {
        return Promise<Void> { fulfill, _ in
            
            if verify {
                guard let _ = TokenStorage.currentToken else {
                    throw VerifiableError.AuthenticationRequired
                }
            }
            
            fulfill()
        }
    }
    
    func verifyAccountType() -> Promise<Void> {
        return Promise<Void> { fulfill, _ in
            
            guard let user = UserStorage.currentUser where user.accountType == .Team || user.accountType == .Player else {
                throw VerifiableError.WrongAccountType
            }
            
            fulfill()
        }
    }
}


