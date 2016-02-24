//
//  User.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CoreData

class ManagedUser: NSManagedObject {
    @NSManaged var mngd_identifier: String
    @NSManaged var mngd_name: String?
    @NSManaged var mngd_username: String
    @NSManaged var mngd_avatarString: String?
    @NSManaged var mngd_shotsCount: Int
    @NSManaged var mngd_accountType: String?
}

extension ManagedUser: UserType {
    var identifier: String { return mngd_identifier }
    var name: String? { return mngd_name }
    var username: String { return mngd_username }
    var avatarString: String? { return mngd_avatarString }
    var shotsCount: Int { return mngd_shotsCount }
    var accountType: UserAccountType? {
        guard let mngd_accountType = mngd_accountType else {
            return nil
        }
        return UserAccountType(rawValue: mngd_accountType)
    }
}
