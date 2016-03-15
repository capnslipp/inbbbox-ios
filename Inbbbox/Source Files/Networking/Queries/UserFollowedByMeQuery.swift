//
//  UserFollowedByMeQuery.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UserFollowedByMeQuery: Query {
    
    let method = Method.GET
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(user: UserType) {
        path = "/user/following/" + user.identifier
    }
}
