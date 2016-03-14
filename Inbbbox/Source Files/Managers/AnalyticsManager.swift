//
//  AnalyticsManager.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 10.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum AnalyticScreen: String {
    case LoginViewScreenName = "Login View",
        FolloweesViewScreenName = "Followees View",
        ShotsViewScreenName = "Shots View",
        SettingsViewScreenName = "Settings View",
        BucketsViewScreenName = "Buckets View",
        LikesViewScreenName = "Likes View",
        ShotDetailsViewScreenName = "Shot Details View",
        ShotBucketsViewScreenName = "Shot Buckets View"
}

struct AnalyticKeys {
    
    struct Login {
        static let LoginCategory = "Login"
        static let LoginSuccededAction = "Login success"
        static let LoginFailedAction = "Login failed"
        static let LoginAsGuest = "Logged as guest"
    }
    
}

class AnalyticsManager {
    
    class func setupAnalytics() {
        GAI.sharedInstance().trackerWithTrackingId(Dribbble.GATrackingId)
    }
    
    class func trackScreen(screen: AnalyticScreen) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screen.rawValue)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    class func sendEvent(category: String, action: String, label: String! = nil, value: NSNumber! = nil) {
        let tracker = GAI.sharedInstance().defaultTracker
        let event = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject : AnyObject]
        tracker.send(event)
    }
    
    class func likeShot() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var value = defaults.integerForKey("like")
        value = value + 1
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(GAIFields.customDimensionForIndex(1), value: String(value))
    }
}
