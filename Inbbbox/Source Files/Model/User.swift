//
//  User.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

final class User: NSObject  {

    let identifier: String
    let name: String?
    let username: String
    let avatarString: String?
    let shotsCount: Int
    
    init(json: JSON) {
        identifier = json[Key.Identifier.rawValue].stringValue
        name = json[Key.Name.rawValue].string
        username = json[Key.Username.rawValue].stringValue
        avatarString = json[Key.Avatar.rawValue].string
        shotsCount = json[Key.ShotsCount.rawValue].intValue
    }
    
    required init(coder aDecoder: NSCoder) {
        identifier = aDecoder.decodeObjectForKey(Key.Identifier.rawValue) as! String
        name = aDecoder.decodeObjectForKey(Key.Name.rawValue) as? String
        username = aDecoder.decodeObjectForKey(Key.Username.rawValue) as! String
        avatarString = aDecoder.decodeObjectForKey(Key.Avatar.rawValue) as? String
        shotsCount = aDecoder.decodeObjectForKey(Key.ShotsCount.rawValue) as? Int ?? 0
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: Key.Identifier.rawValue)
        aCoder.encodeObject(name, forKey: Key.Name.rawValue)
        aCoder.encodeObject(username, forKey: Key.Username.rawValue)
        aCoder.encodeObject(avatarString, forKey: Key.Avatar.rawValue)
        aCoder.encodeObject(shotsCount, forKey: Key.ShotsCount.rawValue)
    }
}

private extension User {
    
    enum Key: String {
        case Identifier = "id"
        case Name = "name"
        case Username = "username"
        case Avatar = "avatar_url"
        case ShotsCount = "shots_count"
    }
}

extension User: NSSecureCoding {
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}

extension User: Mappable {
    static var map: JSON -> User {
        return { json in
            User(json: json)
        }
    }
}

extension User: CustomDebugStringConvertible {
    
    override var debugDescription: String {
        return
            "<Class: " + String(self.dynamicType) + "> " +
            "{ " +
                "ID: " + identifier + ", " +
                "Username: " + username + ", " +
                "Name: " + (name ?? "unknown") +
            " }"
    }
}
