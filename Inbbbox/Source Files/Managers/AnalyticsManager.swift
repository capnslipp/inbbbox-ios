//
//  AnalyticsManager.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 10.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum AnalyticsScreen: String {
    case LoginView, FolloweesView, ShotsView, SettingsView, BucketsView, LikesView, ShotDetailsView, ShotBucketsView
}

enum AnalyticsLoginEvent: String {
    case LoginSucceeded, LoginFailed, LoginAsGuest
}

enum AnalyticsUserActionEvent: String {
    case Like, AddToBucket, Comment, SwipeDown
}

class AnalyticsManager {

    class func setupAnalytics() {
        guard let trackingId = Dribbble.GATrackingId else {
            return
        }
        GAI.sharedInstance().trackerWithTrackingId(trackingId)
    }

    class func trackScreen(screen: AnalyticsScreen) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        tracker.set(kGAIScreenName, value: screen.rawValue)

        let screenView = GAIDictionaryBuilder.createScreenView().build() as [NSObject:AnyObject]
        tracker.send(screenView)
    }

    class func trackLoginEvent(loginEvent: AnalyticsLoginEvent) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        let event = GAIDictionaryBuilder.createEventWithCategory("Login", action: loginEvent.rawValue, label: nil, value: nil).build() as [NSObject:AnyObject]
        tracker.send(event)
    }

    class func trackUserActionEvent(userActionEvent: AnalyticsUserActionEvent) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        let event = GAIDictionaryBuilder.createEventWithCategory("UserAction", action: userActionEvent.rawValue, label: nil, value: nil).build() as [NSObject:AnyObject]
        tracker.send(event)
    }
}
