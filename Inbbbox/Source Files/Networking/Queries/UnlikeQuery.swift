//
//  UnlikeQuery.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 17/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UnlikeQuery: Query {
    
    let method = Method.DELETE
    let path: String
    var parameters = Parameters(encoding: .JSON)
    
    init(shot: Shot) {
        path = "/shots/" + shot.identifier + "/like"
    }
}
