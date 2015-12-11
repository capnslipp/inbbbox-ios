//
//  SecureNetworkService.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol SecureNetworkService: NetworkService {}

extension SecureNetworkService {
    /// Use https scheme as default for secure network service
    var scheme: String {
        return "https"
    }
}
