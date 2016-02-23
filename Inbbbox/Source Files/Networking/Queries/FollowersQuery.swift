//
//  FollowersQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct FollowersQuery: Query {
    
    let method = Method.GET
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    /**
    Initialize query for list the authenticated user’s followers.
    */
    init() {
        path = "/user/followers"
    }
    
    /**
     Initialize query for list a given user’s followers.
     */
    init(followersOfUser user: UserType) {
        path = "/users/\(user.username)/followers"
    }
}
