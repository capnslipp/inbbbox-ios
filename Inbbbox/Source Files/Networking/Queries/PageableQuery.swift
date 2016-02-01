//
//  PageableQuery.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct PageableQuery: Query {
    
    let method = Method.GET
    let path: String
    var parameters = Parameters(encoding: .URL)
    
    init(path: String) {
        self.path = path
    }
    
    init(path: String, queryItems: [NSURLQueryItem]?) {
        self.path = path
        queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
    }
}
