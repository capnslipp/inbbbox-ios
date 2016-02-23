//
//  ManagedShot.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import CoreData

class ManagedShot: NSManagedObject {

    @NSManaged var mngd_identifier: String
    @NSManaged var mngd_title: String
    @NSManaged var mngd_htmlDescription: NSAttributedString?
    @NSManaged var mngd_user: ManagedUser
    @NSManaged var mngd_shotImage: ManagedShotImage
    @NSManaged var mngd_createdAt: NSDate
    @NSManaged var mngd_animated: Bool
    @NSManaged var mngd_likesCount: NSNumber
    @NSManaged var mngd_viewsCount: NSNumber
    @NSManaged var mngd_commentsCount: NSNumber
    @NSManaged var mngd_bucketsCount: NSNumber
    @NSManaged var mngd_team: ManagedTeam?

    @NSManaged var liked: Bool
    @NSManaged var projects: NSSet?
}

extension ManagedShot: ShotType {

    var identifier: String { return mngd_identifier }
    var title: String { return mngd_title }
    var htmlDescription: NSAttributedString? { return mngd_htmlDescription }
    var user: UserType { return mngd_user }
    var shotImage: ShotImageType { return mngd_shotImage }
    var createdAt: NSDate { return mngd_createdAt }
    var animated: Bool { return mngd_animated }
    var likesCount: UInt { return mngd_likesCount.unsignedIntegerValue }
    var viewsCount: UInt { return mngd_viewsCount.unsignedIntegerValue }
    var commentsCount: UInt { return mngd_commentsCount.unsignedIntegerValue }
    var bucketsCount: UInt { return mngd_bucketsCount.unsignedIntegerValue }
    var team: TeamType? { return mngd_team }
}
