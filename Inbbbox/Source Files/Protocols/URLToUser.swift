//
//  URLToUser.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 31.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Converts URL represantation of user to user object.
/// Helps with using TTTAttributedLabel in the project.

protocol URLToUser {
    
    /**
     Converts URL represantation of user to user object.
     
     - parameter url: url which is converted to user
     
     - returns: user converted from URL.
     */
    
    func userForURL(url: NSURL) -> UserType?
    
}
