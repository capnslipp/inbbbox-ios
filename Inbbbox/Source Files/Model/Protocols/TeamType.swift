//
//  ShotImageType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//


import Foundation

protocol TeamType {
    var identifier: String { get }
    var name: String { get }
    var username: String { get }
    var avatarURL: NSURL? { get }
    var createdAt: NSDate { get }
}
