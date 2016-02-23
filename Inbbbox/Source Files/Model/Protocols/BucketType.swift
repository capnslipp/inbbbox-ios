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
    var htmlDescription: NSAttributedString? { get }
    var shotsCount: Int { get }
    var createdAt: NSDate { get }
}