//
//  CreateCommentQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 10/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct CreateCommentQuery: Query {
    
    let method = Method.POST
    let path: String
    var parameters = Parameters(encoding: .JSON)
    
    init(shot: ShotType, body: String) {
        path = "/shots/" + shot.identifier + "/comments"
        parameters["body"] = body
    }
}
