//
//  Bucket.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 27/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Bucket {
    
    let identifier: String
    let name: String
    let description: NSAttributedString?
    let shotsCount: Int
    let createdAt: NSDate
    
}

extension Bucket: Mappable {
    static var map: JSON -> Bucket {
        return { json in
            
            let stringDate = json[Key.CreatedAt.rawValue].stringValue
            let htmlDescription = json[Key.Description.rawValue].string
            
            return Bucket(
                identifier: json[Key.Identifier.rawValue].stringValue,
                name: json[Key.Name.rawValue].stringValue,
                description: NSAttributedString(htmlString: htmlDescription),
                shotsCount: json[Key.ShotsCount.rawValue].intValue,
                createdAt: Formatter.Date.Timestamp.dateFromString(stringDate)!
            )
        }
    }

    private enum Key: String {
        case Identifier = "id"
        case Name = "name"
        case Description = "description"
        case CreatedAt = "created_at"
        case ShotsCount = "shots_count"
    }
}

extension Bucket: Equatable {}

func ==(lhs: Bucket, rhs: Bucket) -> Bool {
    return lhs.identifier == rhs.identifier
}
