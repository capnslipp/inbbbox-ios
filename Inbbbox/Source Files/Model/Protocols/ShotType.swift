//
//  ShotType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/16/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotType {
    var identifier: String { get }

    /// The title of the shot
    var title: String { get }

    /// A description of the shot
    var attributedDescription: NSAttributedString? { get }

    /**
     Owner of this shot

     - returns: User
     */
    var user: UserType { get }

    /**
     Shot image can be a GIF, JPG, or PNG

     - returns: Shot image with available URLs
     */
    var shotImage: ShotImageType { get }

    /// Date when shot was created
    var createdAt: NSDate { get }

    /// Indicates whether Shot image is GIF
    var animated: Bool { get }

    /// Total number of likes from all users
    var likesCount: UInt { get }

    /// Total number of views
    var viewsCount: UInt { get }

    /// Total number of comments
    var commentsCount: UInt { get }

    /// Total number of buckets, shot is contained in
    var bucketsCount: UInt { get }

    /**
     Team associated with the Shot

     - returns: Team
    */
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
