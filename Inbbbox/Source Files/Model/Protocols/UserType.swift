//
//  UserType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum UserAccountType: String {
    case User = "User"
    case Player = "Player"
    case Team = "Team"
}

protocol UserType {
    var identifier: String { get }
    var name: String? { get }
    var username: String { get }
    var avatarString: String? { get }
    var shotsCount: Int { get }
    var accountType: UserAccountType? { get }
}
