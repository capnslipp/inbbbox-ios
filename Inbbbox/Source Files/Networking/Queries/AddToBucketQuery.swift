//
//  AddToBucketQuery.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct AddToBucketQuery: Query {
    
    let method = Method.PUT
    let path: String
    var parameters = Parameters(encoding: .JSON)
    
    init(shot: Shot, bucket: Bucket) {
        path = "/buckets/" + bucket.identifier.stringValue + "/shots"
        parameters["shot_id"] = shot.identifier
    }
}
