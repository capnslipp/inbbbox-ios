//
//  Project.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 15/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Project {
    
    let identifier: String
    let name: String?
    let description: NSAttributedString?
    let createdAt: NSDate
    let shotsCount: UInt
    
}

extension Project: Mappable {
    static var map: JSON -> Project {
        return { json in
            
            let stringDate = json[Key.CreatedAt.rawValue].stringValue
            let htmlDescription: NSAttributedString? = {
                guard let htmlString = json[Key.Description.rawValue].string else {
                    return nil
                }
                return NSAttributedString(htmlString: htmlString)
            }()

            return Project(
                identifier: json[Key.Identifier.rawValue].stringValue,
                name: json[Key.Name.rawValue].string,
                description: htmlDescription,
                createdAt: Formatter.Date.Timestamp.dateFromString(stringDate)!,
                shotsCount: json[Key.ShotsCount.rawValue].uIntValue
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

extension Project: Equatable {}

func ==(lhs: Project, rhs: Project) -> Bool {
    return lhs.identifier == rhs.identifier
}
