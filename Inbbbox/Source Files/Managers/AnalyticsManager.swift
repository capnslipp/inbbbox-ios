//
//  AnalyticsManager.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 10.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum AnalyticsScreen: String {
    case LoginView = "Login View",
         FolloweesView = "Followees View",
         ShotsView = "Shots View",
         SettingsView = "Settings View",
         BucketsView = "Buckets View",
         LikesView = "Likes View",
         ShotDetailsView = "Shot Details View",
         ShotBucketsView = "Shot Buckets View"
}

enum AnalyticsLoginEvent: String {
    case LoginSucceeded = "Login succeeded",
         LoginFailed = "Login failed",
         LoginAsGuest = "Login as guest"
}

enum AnalyticsAction: UInt {
    case Like = 1,
         AddToBucket,
         Comment,
         SwipeDown
}

class AnalyticsManager {

    class func setupAnalytics() {
        GAI.sharedInstance().trackerWithTrackingId(Dribbble.GATrackingId)
    }

    class func trackScreen(screen: AnalyticsScreen) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screen.rawValue)

        let screenView = GAIDictionaryBuilder.createScreenView().build() as [NSObject:AnyObject]
        tracker.send(screenView)
    }

    class func trackLoginEvent(loginEvent: AnalyticsLoginEvent) {
        let tracker = GAI.sharedInstance().defaultTracker
        let event = GAIDictionaryBuilder.createEventWithCategory("Login", action: loginEvent.rawValue, label: nil, value: nil).build() as [NSObject:AnyObject]
        tracker.send(event)
    }

    class func trackAction(action: AnalyticsAction) {
        let tracker = GAI.sharedInstance().defaultTracker
        let metricForAction = GAIFields.customMetricForIndex(action.rawValue)
        tracker.set(metricForAction, value: 1.stringValue)
    }
}
