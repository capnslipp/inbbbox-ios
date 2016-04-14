//
//  ManagedShotImage.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CoreData

class ManagedShotImage: NSManagedObject {

    @NSManaged var mngd_hidpiURL: String?
    @NSManaged var mngd_normalURL: String
    @NSManaged var mngd_teaserURL: String
}

extension ManagedShotImage: ShotImageType {

    var hidpiURL: NSURL? {
        guard let encodedString = mngd_hidpiURL?.stringByAddingPercentEncodingWithAllowedCharacters(
        NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return nil
        }
        return NSURL(string: encodedString)
    }
    var normalURL: NSURL {
        let encodedString = mngd_normalURL.stringByAddingPercentEncodingWithAllowedCharacters(
        NSCharacterSet.URLQueryAllowedCharacterSet())
        return NSURL(string: encodedString!)!

    }
    var teaserURL: NSURL {
        let encodedString = mngd_teaserURL.stringByAddingPercentEncodingWithAllowedCharacters(
        NSCharacterSet.URLQueryAllowedCharacterSet())
        return NSURL(string: encodedString!)!
    }
}
