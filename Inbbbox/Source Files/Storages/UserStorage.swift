//
//  UserStorage.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 05/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import KeychainAccess

class UserStorage {

    private static let KeychainService = "co.netguru.inbbbox.keychain.user"
    private static let keychain = Keychain(service: KeychainService)

    class var currentUser: User? {
        guard let data = keychain[data: Key.Token.rawValue] else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
    }

    class var userIsSignedIn: Bool {
        return currentUser != nil
    }

    class func storeUser(user: User) {
        keychain[data: Key.Token.rawValue] = NSKeyedArchiver.archivedDataWithRootObject(user)
    }

    class func clear() {
        keychain[Key.Token.rawValue] = nil
    }
}

private extension UserStorage {

    enum Key: String {
        case Token = "co.netguru.inbbbox.keychain.user.key"
    }
}
