//
//  UserQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UserQuery: Query {
    
    let method = Method.GET
    let path: String
    let service: SecureNetworkService = DribbbleNetworkService()
    var parameters = Parameters(encoding: .URL)
    
    init() {
        path = "/user"
    }
    
    init(identifier: String) {
        path = "/users/" + identifier
    }
}
