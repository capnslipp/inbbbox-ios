//
//  FollowUserQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct FollowUserQuery: Query {
    
    let method = Method.PUT
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(user: User) {
        path = "/users/" + user.identifier + "/follow"
    }
}
