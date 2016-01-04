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
    
    class func registerNotification(forUserID userID: String, time: NSDate) -> UILocalNotification? {
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        
        unregisterNotification(forUserID: userID)
        
        return createNotification(forUserID: userID, time: time)
    }
    
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
        localNotification.alertBody = NSLocalizedString("Check Inbbbox!", comment: "") // NGRTemp: temp text
        localNotification.alertAction = NSLocalizedString("Show", comment: "") // NGRTemp: temp text
        localNotification.repeatInterval = .Day
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        return localNotification
    }
    
    class func destroyNotification(notificationID notificationToDelete: UILocalNotification) {
        UIApplication.sharedApplication().cancelLocalNotification(notificationToDelete)
    }
    
    class func registeredNotification(forUserID userID: String) -> UILocalNotification? {
        
        guard let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {
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
