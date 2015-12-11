//
//  Query.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

protocol Query {
    var method: Method { get }
    var path: String { get }
    var parameters: Parameters? { get set }
    var service: SecureNetworkService { get }
}
