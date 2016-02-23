//
//  DeleteCommentQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 11/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct DeleteCommentQuery: Query {
    
    let method = Method.DELETE
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(shot: ShotType, comment: CommentType) {
        path = "/shots/" + shot.identifier + "/comments/" + comment.identifier
    }
}
