//
//  CommentType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol CommentType {
    var identifier: String { get }
    var body: NSAttributedString? { get }
    var createdAt: NSDate { get }
    var user: UserType { get }
}