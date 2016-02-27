//
//  ProjectType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ProjectType {
    var identifier: String { get }
    var name: String? { get }
    var attributedDescription: NSAttributedString? { get }
    var createdAt: NSDate { get }
    var shotsCount: UInt { get }
}
