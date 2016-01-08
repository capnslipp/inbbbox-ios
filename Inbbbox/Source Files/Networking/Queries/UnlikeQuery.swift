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
    let service: SecureNetworkService = DribbbleNetworkService()
    var parameters = Parameters(encoding: .JSON)
    
    init(shotID: String) {
        path = "/shots/" + shotID + "/like"
    }
}
