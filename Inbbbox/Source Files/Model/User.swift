//
//  User.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

final class User: NSObject, UserType {

    let identifier: String
    let name: String?
    let username: String
    let avatarURL: NSURL?
    let shotsCount: UInt
    let accountType: UserAccountType?


    init(json: JSON) {
        identifier = json[Key.Identifier.rawValue].stringValue
        name = json[Key.Name.rawValue].string
        username = json[Key.Username.rawValue].stringValue
        avatarURL = json[Key.Avatar.rawValue].URL
        shotsCount = json[Key.ShotsCount.rawValue].uIntValue
        accountType = UserAccountType(rawValue: json[Key.AccountType.rawValue].stringValue)
    }

    required init(coder aDecoder: NSCoder) {
        identifier = aDecoder.decodeObjectForKey(Key.Identifier.rawValue) as? String ?? ""
        name = aDecoder.decodeObjectForKey(Key.Name.rawValue) as? String
        username = aDecoder.decodeObjectForKey(Key.Username.rawValue) as? String ?? ""
        avatarURL = aDecoder.decodeObjectForKey(Key.Avatar.rawValue) as? NSURL
        shotsCount = aDecoder.decodeObjectForKey(Key.ShotsCount.rawValue) as? UInt ?? 0
        accountType = {
            if let key = aDecoder.decodeObjectForKey(Key.AccountType.rawValue) as? String {
                return UserAccountType(rawValue: key)
            }
            return nil
        }()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: Key.Identifier.rawValue)
        aCoder.encodeObject(name, forKey: Key.Name.rawValue)
        aCoder.encodeObject(username, forKey: Key.Username.rawValue)
        aCoder.encodeObject(avatarURL, forKey: Key.Avatar.rawValue)
        aCoder.encodeObject(shotsCount, forKey: Key.ShotsCount.rawValue)
        aCoder.encodeObject(accountType?.rawValue, forKey: Key.AccountType.rawValue)
    }
}

private extension User {

    enum Key: String {
        case Identifier = "id"
        case Name = "name"
        case Username = "username"
        case Avatar = "avatar_url"
        case ShotsCount = "shots_count"
        case AccountType = "type"
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

extension User {

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
