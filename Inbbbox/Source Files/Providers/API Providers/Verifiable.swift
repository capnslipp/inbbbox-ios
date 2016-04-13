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
    case IncorrectTextLength(UInt)
}

protocol Verifiable {

    func verifyAuthenticationStatus(verify: Bool) -> Promise<Void>
    func verifyAccountType() -> Promise<Void>
    func verifyTextLength(text: String, min: UInt, max: UInt) -> Promise<Void>
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

    func verifyTextLength(text: String, min minUInt: UInt, max maxUInt: UInt) -> Promise<Void> {
        return Promise<Void> { fulfill, _ in

            let textWithoutWhitespaces = text.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
            let trueMin = min(minUInt, maxUInt)
            let trueMax = max(minUInt, maxUInt)

            if textWithoutWhitespaces.characters.count < Int(trueMin) {
                throw VerifiableError.IncorrectTextLength(trueMin)

            } else if maxUInt != UInt.max {
                if textWithoutWhitespaces.characters.count > Int(trueMax) {
                    throw VerifiableError.IncorrectTextLength(trueMax)
                }
            }

            fulfill()
        }
    }
}
