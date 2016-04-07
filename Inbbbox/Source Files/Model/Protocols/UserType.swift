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
    var avatarURL: NSURL? { get }
    var shotsCount: UInt { get }
    var accountType: UserAccountType? { get }
}

func ==(lhs: UserType, rhs: UserType) -> Bool {
    return lhs.identifier == rhs.identifier
}

func ==(lhs: [UserType], rhs: [UserType]) -> Bool {
    
    guard lhs.count == rhs.count else { return false }
    
    var indexingGenerators = (left: lhs.generate(), right: rhs.generate())
    
    var isEqual = true
    while let leftElement = indexingGenerators.left.next(), rightElement = indexingGenerators.right.next() where isEqual {
        isEqual = leftElement == rightElement
    }
    
    return isEqual
}

func !=(lhs: [UserType], rhs: [UserType]) -> Bool {
    return !(lhs == rhs)
}
