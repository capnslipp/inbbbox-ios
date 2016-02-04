//
//  BucketSpecExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import SwiftyJSON

@testable import Inbbbox

extension Bucket {
    
    static func fixtureBucket() -> Bucket {
        let json = JSONSpecLoader.sharedInstance.jsonWithResourceName("Bucket")
        return Bucket.map(json)
    }
}
