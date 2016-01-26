//
//  ShotExtension.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 1/26/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import SwiftyJSON

@testable import Inbbbox

extension Shot {
    static func emptyShotForBundle(bundle: NSBundle) -> Shot {
        let file = bundle.pathForResource("Shot", ofType:"json")
        let data = NSData(contentsOfFile: file!)
        let json = JSON(data: data!)
        return Shot.map(json)
    }
}
