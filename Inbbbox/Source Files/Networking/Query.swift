//
//  Query.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Method for HTTP query.
enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

/// Query for request.
protocol Query {
    /// Query's method.
    var method: Method { get }
    /// Query's path.
    var path: String { get }
    /// Query's service.
    var service: SecureNetworkService { get }
    /// Query's parameters.
    var parameters: Parameters { get set }
}

extension Query {

    var service: SecureNetworkService {
        return DribbbleNetworkService()
    }
}
