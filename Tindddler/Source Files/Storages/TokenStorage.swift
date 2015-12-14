//
//  TokenStorage.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

final class TokenStorage {
    
    private var KeychainService = "co.netguru.tindddler.keychain.token"
    
    class var currentToken: String {
        // NGRTodo: Implement token read from Keychain service
        return ""
    }
    
    class func storeToken(token: String) {
        // NGRTodo: Implement secure token storing procedure in Keychain service
    }
    
    class func clear() {
        // NGRTodo: Implement removing stored token in Keychain service
    }
}
