//
//  ManagedComment.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CoreData

class ManagedTeam: NSManagedObject {
    @NSManaged var mngd_identifier: String
    @NSManaged var mngd_name: String
    @NSManaged var mngd_username: String
    @NSManaged var mngd_avatarURL: String?
    @NSManaged var mngd_createdAt: NSDate
}

extension ManagedTeam: TeamType {
    var identifier: String { return mngd_identifier }
    var name: String { return mngd_name }
    var username: String { return mngd_username }
    var avatarURL: NSURL? {
        guard let encodedString =
                mngd_avatarURL?.stringByAddingPercentEncodingWithAllowedCharacters(
                NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return nil
        }
        return NSURL(string: encodedString)
    }
    var createdAt: NSDate { return mngd_createdAt }
}
