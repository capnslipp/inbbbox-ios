//
//  HeaderAuthorizable.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias HTTPHeader = (header: String, value: String)

/// Use this protocol to authorize with header
protocol HeaderAuthorizable {
    func authorizationHeader(token: String) -> HTTPHeader
}

extension HeaderAuthorizable {
    func authorizationHeader(token: String) -> HTTPHeader {
        return ("Authorization", "Bearer " + token)
    }
}
