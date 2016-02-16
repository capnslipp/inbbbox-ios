//
//  ProjectsQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 15/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct ProjectsQuery: Query {
    
    let method = Method.GET
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(shot: Shot) {
        path = "/shots/" + shot.identifier + "/projects"
    }
}
