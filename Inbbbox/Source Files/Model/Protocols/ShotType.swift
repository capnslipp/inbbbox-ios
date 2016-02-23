//
//  ShotType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/16/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/**
 Shot model. Can contain much more properties. See http:developer.dribbble.com/v1/shots/#get-a-shot.
 */

protocol ShotType {
    var identifier: String { get }
    var title: String { get }
    var htmlDescription: NSAttributedString? { get }
    var user: UserType { get }
    var shotImage: ShotImageType { get }
    var createdAt: NSDate { get }
    var animated: Bool { get }
    var likesCount: UInt { get }
    var viewsCount: UInt { get }
    var commentsCount: UInt { get }
    var bucketsCount: UInt { get }
    var team: TeamType? { get }
}
