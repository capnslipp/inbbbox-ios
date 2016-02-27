//
//  UnfollowUserQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UnfollowUserQuery: Query {
    
    let method = Method.DELETE
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(user: UserType) {
        path = "/users/" + user.identifier + "/follow"
    }
}
