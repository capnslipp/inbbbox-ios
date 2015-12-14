//
//  Shot.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Shot {
    let identifier: String
    let title: String?
    let description: String?
    let user: User
}

extension Shot: Mappable {
    static var map: JSON -> Shot {
        return { json in
            Shot(identifier: json[Key.Identifier.rawValue].stringValue,
                title: json[Key.Title.rawValue].string,
                description: json[Key.Description.rawValue].string,
                user: User.map(json[Key.User.rawValue])
            )
        }
    }

    private enum Key: String {
        case Identifier = "id"
        case Title = "title"
        case Description = "description"
        case User = "user"
    }
}
