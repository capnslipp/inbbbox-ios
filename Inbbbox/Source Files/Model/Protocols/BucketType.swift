//
//  BucketType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol BucketType {

    /// Unique identifier
    var identifier: String { get }

    /// Name of the Bucket
    var name: String { get }

    /// Description of the Bucket
    var attributedDescription: NSAttributedString? { get }

    /// Number of shots contained in this Bucket
    var shotsCount: UInt { get }

    /// Date when Bucket was created
    var createdAt: NSDate { get }

    /// Owner of this Bucket
    ///
    /// - returns: User
    var owner: UserType { get }
}

func ==(lhs: BucketType, rhs: BucketType) -> Bool {
    return lhs.identifier == rhs.identifier
}

func ==(lhs: [BucketType], rhs: [BucketType]) -> Bool {

    guard lhs.count == rhs.count else { return false }

    var indexingGenerators = (left: lhs.generate(), right: rhs.generate())

    var isEqual = true
    while let leftElement = indexingGenerators.left.next(), rightElement = indexingGenerators.right.next() where isEqual {
        isEqual = leftElement == rightElement
    }

    return isEqual
}

func !=(lhs: [BucketType], rhs: [BucketType]) -> Bool {
    return !(lhs == rhs)
}
