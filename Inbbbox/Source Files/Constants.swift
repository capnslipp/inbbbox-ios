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

     /// `ClientID` is used to communicate with dribbble API.
     /// Value is set during project setup, after typing `pod install`,
     /// then securely stored in OSX Keychain.
    static let ClientID: String = SecretKeysProvider.secretValueForKey("ClientID")!

    /// `ClientSecret` is used to communicate with dribbble API.
    /// Value is set during project setup, after typing `pod install`,
    /// then securely stored in OSX Keychain.
    static let ClientSecret: String = SecretKeysProvider.secretValueForKey("ClientSecret")!

     /// `ClientAccessToken` is used to communicate with dribbble API.
     /// Value is set during project setup, after typing `pod install`,
     /// then securely stored in OSX Keychain.
    static let ClientAccessToken: String = SecretKeysProvider.secretValueForKey("ClientAccessToken")!
    static let CallbackURLString = "https://inbbbox.netguru.co"

    static let RequestTokenURLString = "https://dribbble.com/oauth/authorize"
    static let AccessTokenURLString = "https://dribbble.com/oauth/token"

    /// Specifies type of access to dribbble API. By default this value is set to `public+write+comment`.
    static let Scope = "public+write+comment"

    /// Daily request limit. By default it is set to 1440.
    static let RequestPerDayLimitForAuthenticatedUser = UInt(1440)

    /// Tracking ID used for Google Analytics.
    static var GATrackingId: String? {
#if ENV_PRODUCTION
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
#if ENV_PRODUCTION
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
