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
    var attributedDescription: NSAttributedString? { get }
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

func ==(lhs: ShotType, rhs: ShotType) -> Bool {
    return lhs.identifier == rhs.identifier
}

func ==(lhs: [ShotType], rhs: [ShotType]) -> Bool {
    
    guard lhs.count == rhs.count else { return false }
    
    var indexingGenerators = (left: lhs.generate(), right: rhs.generate())
    
    var isEqual = true
    while let leftElement = indexingGenerators.left.next(), rightElement = indexingGenerators.right.next() where isEqual {
        isEqual = leftElement == rightElement
    }
    
    return isEqual
}

func !=(lhs: [ShotType], rhs: [ShotType]) -> Bool {
    return !(lhs == rhs)
}
