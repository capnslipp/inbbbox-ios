//
//  AnalyticsManager.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 10.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Defines which views can be tracked.
enum AnalyticsScreen: String {
    case LoginView, FolloweesView, ShotsView, SettingsView, BucketsView, LikesView, ShotDetailsView, ShotBucketsView
}

/// Defines which login events can be tracked.
enum AnalyticsLoginEvent: String {
    case LoginSucceeded, LoginFailed, LoginAsGuest
}

/// Defines which user actions can be tracked.
enum AnalyticsUserActionEvent: String {
    case Like, AddToBucket, Comment, SwipeDown
}

class AnalyticsManager {

    /// Setup analytics using Tracking ID.
    class func setupAnalytics() {
        guard let trackingId = Dribbble.GATrackingId else {
            return
        }
        GAI.sharedInstance().trackerWithTrackingId(trackingId)
    }

    /// Method to track specific screen.
    ///
    /// - parameter screen: Screen to track.
    class func trackScreen(screen: AnalyticsScreen) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        tracker.set(kGAIScreenName, value: screen.rawValue)

        let screenView = GAIDictionaryBuilder.createScreenView().build() as [NSObject:AnyObject]
        tracker.send(screenView)
    }

    /// Method to track login event.
    ///
    /// - parameter loginEvent: Login event to track.
    class func trackLoginEvent(loginEvent: AnalyticsLoginEvent) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        let event = GAIDictionaryBuilder.createEventWithCategory("Login", action: loginEvent.rawValue, label: nil, value: nil).build() as [NSObject:AnyObject]
        tracker.send(event)
    }

    /// Method to track user action event.
    ///
    /// - parameter userActionEvent: action to track.
    class func trackUserActionEvent(userActionEvent: AnalyticsUserActionEvent) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        let event = GAIDictionaryBuilder.createEventWithCategory("UserAction", action: userActionEvent.rawValue, label: nil, value: nil).build() as [NSObject:AnyObject]
        tracker.send(event)
    }
}
