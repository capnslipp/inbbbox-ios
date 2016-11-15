//
//  Attachement.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 15.11.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Attachement {
    let identifier: String
    let thumbnailURL: NSURL?
    let imageURL: NSURL?
}

extension Attachement: Mappable {
    
    static var map: JSON -> Attachement {
        return { json in
            
            return Attachement(identifier: json[Key.Identifier.rawValue].stringValue,
                               thumbnailURL: json[Key.ThumbnailURL.rawValue].URL,
                               imageURL: json[Key.ImageURL.rawValue].URL)
        }
    }
    
    private enum Key: String {
        case Identifier = "id"
        case ThumbnailURL = "thumbnail_url"
        case ImageURL = "url"
    }
}
