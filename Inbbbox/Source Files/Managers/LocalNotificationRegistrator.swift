//
//  LocalNotificationRegistrator.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class LocalNotificationRegistrator {

    private static let LocalNotificationUserIDKey = "notificationID"

    /// Registers user for local notifications.
    ///
    /// - parameter userID: User ID.
    /// - parameter time:   Fire date of notification.
    ///
    /// - returns: Local Notification object.
    class func registerNotification(forUserID userID: String, time: NSDate)
                    -> UILocalNotification? {

        if let localNotificationSettings =
                UIApplication.sharedApplication().currentUserNotificationSettings() {

            guard localNotificationSettings.types == [.Alert, .Sound] else {
                return nil
            }

            unregisterNotification(forUserID: userID)

            return createNotification(forUserID: userID, time: time)

        } else {
            return nil
        }
    }

    /// Unregisters user from local notifications.
    /// - parameter forUserID: User ID.
    class func unregisterNotification(forUserID userID: String) {

        if let registeredNotification = registeredNotification(forUserID: userID) {
            destroyNotification(notificationID: registeredNotification)
        }
    }
}

// MARK: Private

private extension LocalNotificationRegistrator {

    class func createNotification(forUserID userID: String, time: NSDate) -> UILocalNotification {

        let localNotification = UILocalNotification()
        localNotification.userInfo = [LocalNotificationUserIDKey: userID]
        localNotification.fireDate = time
        localNotification.alertBody = NSLocalizedString("LocalNotificationRegistrator.AlertBody",
                comment: "Check Inbbbox for daily dose of design shots")
        localNotification.alertAction = NSLocalizedString("LocalNotificationRegistrator.Show",
                comment: "Action for notification")
        localNotification.repeatInterval = .Day

        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        return localNotification
    }

    class func destroyNotification(notificationID notificationToDelete: UILocalNotification) {
        UIApplication.sharedApplication().cancelLocalNotification(notificationToDelete)
    }

    class func registeredNotification(forUserID userID: String) -> UILocalNotification? {

        guard let scheduledLocalNotifications =
                UIApplication.sharedApplication().scheduledLocalNotifications else {
            return nil
        }

        let notifications = scheduledLocalNotifications.filter {
            if let userinfo = $0.userInfo as? [String: String] {
                return userinfo[LocalNotificationUserIDKey] == userID
            }
            return false
        }

        return notifications.first
    }
}
