//
//  CommentType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Interface for Comment.
protocol CommentType {

    /// Unique identifier
    var identifier: String { get }

    /// Comment's content.
    var body: NSAttributedString? { get }

    /// Date when Comment was created.
    var createdAt: NSDate { get }

    /// User which created this comment.
    ///
    /// - returns: User.
    var user: UserType { get }
}
