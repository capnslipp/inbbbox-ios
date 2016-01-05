//
//  ShotImage.swift
//  Inbbbox
//
//  Created by Kamil Tomaszewski on 05/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ShotImage {
    let hidpiURL: NSURL?
    let normalURL: NSURL?
    let teaserURL: NSURL?
}

extension ShotImage: Mappable {
    static var map: JSON -> ShotImage {
        return { json in
            ShotImage(hidpiURL: json[Key.Hidpi.rawValue].URL,
                    normalURL: json[Key.Normal.rawValue].URL,
                    teaserURL: json[Key.Teaser.rawValue].URL
            )
        }
    }
    
    private enum Key: String {
        case Hidpi = "hidpi"
        case Normal = "normal"
        case Teaser = "teaser"
    }
}
