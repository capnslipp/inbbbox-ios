//
//  UpdateCommentQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 11/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UpdateCommentQuery: Query {
    
    let method = Method.PUT
    let path: String
    var parameters = Parameters(encoding: .JSON)
    
    init(shot: Shot, comment: Comment, withBody body: String) {
        path = "/shots/" + shot.identifier + "/comments/" + comment.identifier
        parameters["body"] = body
    }
}
