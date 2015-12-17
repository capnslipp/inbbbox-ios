//
//  User.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let identifier: String
    let name: String?
    let username: String
    let avatarString: String?
}

extension User: Mappable {
    static var map: JSON -> User {
        return { json in
            User(identifier: json[Key.Identifier.rawValue].stringValue,
                name: json[Key.Name.rawValue].string,
                username: json[Key.Username.rawValue].stringValue,
                avatarString: json[Key.Avatar.rawValue].string
            )
        }
    }
    
    private enum Key: String {
        case Identifier = "id"
        case Name = "name"
        case Username = "username"
        case Avatar = "avatar_url"
    }
}
