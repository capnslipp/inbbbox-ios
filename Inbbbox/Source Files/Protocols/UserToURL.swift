//
//  UserToURL.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 31.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Converts user to URL represantation of user.
/// Uses user's identifier to create URL.
/// Helps with using TTTAttributedLabel in the project.

protocol UserToURL {
    
    /**
     Converts user to URL represantation of user.
     
     - parameter user: user who is converted
     
     - returns: URL represantation of user.
     */
    
    func urlForUser(user: UserType) -> NSURL?
    
}

extension UserToURL {
    
    func urlForUser(user: UserType) -> NSURL? {
        return NSURL(string: user.identifier)
    }
    
}
