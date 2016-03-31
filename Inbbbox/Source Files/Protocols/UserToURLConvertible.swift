//
//  UserToURLConvertible.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 31.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Convert user to URL represantation of user and vice versa.
/// Uses user's identifier to create URL.
/// Helps with using TTTAttributedLabel in the project.

protocol UserToURLConvertible {
    
    /**
     Convert user to URL represantation of user.
     
     - parameter user: user who is converted
     
     - returns: URL represantation of user.
     */
    
    func urlForUser(user: UserType) -> NSURL?
    
    /**
     Convert URL represantation of user to user.
     
     - parameter url: url which is converted to user
     
     - returns: user converted from URL.
     */
    
    func userForURL(url: NSURL) -> UserType?
    
}

extension UserToURLConvertible {
    
    func urlForUser(user: UserType) -> NSURL? {
        return NSURL(string: user.identifier)
    }
    
}
