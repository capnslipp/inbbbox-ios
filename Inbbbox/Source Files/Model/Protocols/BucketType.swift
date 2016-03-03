//
//  BucketType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol BucketType {
    var identifier: String { get }
    var name: String { get }
    var attributedDescription: NSAttributedString? { get }
    var shotsCount: Int { get }
    var createdAt: NSDate { get }
    var owner: User { get }
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
