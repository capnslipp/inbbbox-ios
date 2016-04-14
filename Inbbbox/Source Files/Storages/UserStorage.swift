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

    /// Currently signed in user. If there isn't any then returns *nil*.
    class var currentUser: User? {
        guard let data = keychain[data: Key.Token.rawValue] else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
    }

    /// Indicates if there is any signed in user.
    class var isUserSignedIn: Bool {
        return currentUser != nil
    }

    /// Store given user.
    ///
    /// - parameter user: User that should be stored.
    class func storeUser(user: User) {
        keychain[data: Key.Token.rawValue] = NSKeyedArchiver.archivedDataWithRootObject(user)
    }

    /// Clear stored user.
    class func clear() {
        keychain[Key.Token.rawValue] = nil
    }
}

private extension UserStorage {

    enum Key: String {
        case Token = "co.netguru.inbbbox.keychain.user.key"
    }
}
