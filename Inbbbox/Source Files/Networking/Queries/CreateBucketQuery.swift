//
//  CreateBucketQuery.swift
//  Inbbbox
//
//  Created by Peter Bruz on 09/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct CreateBucketQuery: Query {
    
    let method = Method.POST
    let path: String
    var parameters = Parameters(encoding: .JSON)
    
    init(name: String, description: NSAttributedString?) {
        path = "/buckets"
        parameters["name"] = name
        parameters["description"] = description
    }
}
