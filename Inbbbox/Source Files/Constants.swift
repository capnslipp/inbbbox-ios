//
//  Constants.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct Dribbble {
    static let Host = "api.dribbble.com"
    static let APIVersion = "/v1"
    static let ClientID: String = SecretKeysProvider.secretValueForKey("ClientID")!
    static let ClientSecret: String = SecretKeysProvider.secretValueForKey("ClientSecret")!
    static let ClientAccessToken: String = SecretKeysProvider.secretValueForKey("ClientAccessToken")!
    static let CallbackURLString = "https://tindddler.netguru.co"

    static let RequestTokenURLString = "https://dribbble.com/oauth/authorize"
    static let AccessTokenURLString = "https://dribbble.com/oauth/token"
    static let Scope = "public+write+comment"
    static let RequestPerDayLimitForAuthenticatedUser = UInt(1440)

    static var GATrackingId: String? {
#if Production
        if let trackingId = SecretKeysProvider.secretValueForKey("ProductionGATrackingId") {
            return trackingId
        }
#else
        if let trackingId = SecretKeysProvider.secretValueForKey("StagingGATrackingId") {
            return trackingId
        }
#endif
        return nil
    }

    static var HockeySDKIdentifier: String? {
#if Production
        if let identifier = SecretKeysProvider.secretValueForKey("HockeySDKProduction") {
            return identifier
        }
#else
        if let identifier = SecretKeysProvider.secretValueForKey("HockeySDKStaging") {
            return identifier
        }
#endif
        return nil
    }
}
