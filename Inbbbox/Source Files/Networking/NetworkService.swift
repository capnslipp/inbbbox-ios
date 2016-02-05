//
//  NetworkService.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol NetworkService {
    var scheme: String { get }
    var host: String { get }
    var version: String { get }
    
    func authorizeRequest(request: NSMutableURLRequest)
}
