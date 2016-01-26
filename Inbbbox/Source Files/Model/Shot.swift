//
//  Shot.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 Shot model. Can contain much more properties. See http://developer.dribbble.com/v1/shots/#get-a-shot.
 */

struct Shot {
    let identifier: String
    let title: String?
    let description: String?
    let user: User
    let image: ShotImage
    let createdAt: NSDate
    let animated: Bool
}

extension Shot: Mappable {
    static var map: JSON -> Shot {
        return { json in
            print(json)
            let stringDate = json[Key.CreatedAt.rawValue].stringValue
            
            return Shot(
                identifier: json[Key.Identifier.rawValue].stringValue,
                title: json[Key.Title.rawValue].string,
                description: json[Key.Description.rawValue].string,
                user: User.map(json[Key.User.rawValue]),
                image: ShotImage.map(json[Key.Images.rawValue]),
                createdAt: Formatter.Date.Timestamp.dateFromString(stringDate)!,
                animated: json[Key.Animated.rawValue].boolValue
            )
        }
    }

    private enum Key: String {
        case Identifier = "id"
        case Title = "title"
        case Description = "description"
        case User = "user"
        case Images = "images"
        case CreatedAt = "created_at"
        case Animated = "animated"
    }
}

extension Shot: Equatable {}

func ==(lhs: Shot, rhs: Shot) -> Bool {
    return lhs.identifier == rhs.identifier
}
