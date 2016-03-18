//
//  Constants.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Keys

struct Dribbble {
    static let Host = "api.dribbble.com"
    static let APIVersion = "/v1"
    static let ClientID: String = InbbboxKeys().clientID()
    static let ClientSecret: String = InbbboxKeys().clientSecret()
    static let ClientAccessToken: String = InbbboxKeys().clientAccessToken()
    static let CallbackURLString = "https://tindddler.netguru.co"

    static let RequestTokenURLString = "https://dribbble.com/oauth/authorize"
    static let AccessTokenURLString = "https://dribbble.com/oauth/token"
    static let Scope = "public+write+comment"
    static let RequestPerDayLimitForAuthenticatedUser = UInt(1440)
}
