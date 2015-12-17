//
//  NSErrorExtensions.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 11/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSError {
    convenience init(domain: String, code: Int, message: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
