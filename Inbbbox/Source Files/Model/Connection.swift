//
//  Connection.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 01/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Connection {
    
    let identifier: String
    let createdAt: NSDate
    let user: User?
    
}

extension Connection: Mappable {
    static var map: JSON -> Connection {
        return { json in
            
            let stringDate = json[Key.CreatedAt.rawValue].stringValue
            let user: User? = {
                
                if json[Key.Followee.rawValue].dictionary?.count > 0 {
                    return User.map(json[Key.Followee.rawValue])
                    
                } else if json[Key.Follower.rawValue].dictionary?.count > 0 {
                    return User.map(json[Key.Follower.rawValue])
                }
                
                return nil
            }()
            
            return Connection(
                identifier: json[Key.Identifier.rawValue].stringValue,
                createdAt: Formatter.Date.Timestamp.dateFromString(stringDate)!,
                user: user
            )
        }
    }
    
    private enum Key: String {
        case Identifier = "id"
        case CreatedAt = "created_at"
        case Followee = "followee"
        case Follower = "follower"
    }
}

extension Connection: Equatable {}

func ==(lhs: Connection, rhs: Connection) -> Bool {
    return lhs.identifier == rhs.identifier
}
