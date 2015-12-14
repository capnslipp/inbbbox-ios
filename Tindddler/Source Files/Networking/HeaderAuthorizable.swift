//
//  HeaderAuthorizable.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct HTTPHeader {
    typealias Name = String
    typealias Value = String
    
    let name: Name
    let value: Value
}

/// Use this protocol to authorize with header
protocol HeaderAuthorizable {
    func authorizationHeader(token: String) -> HTTPHeader
}

extension HeaderAuthorizable {
    func authorizationHeader(token: String) -> HTTPHeader {
        return HTTPHeader(name: "Authorization", value: "Bearer " + token)
    }
}
