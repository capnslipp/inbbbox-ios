//
//  NotificationManager.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class NotificationManager {
    
    class func registerNotification(forUserID userID: String, time: NSDate) {
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        
        unregisterNotification(forUserID: userID)
        
        createNotification(forUserID: userID, atTime: time)
    }
    
    class func unregisterNotification(forUserID userID: String) {
        
        let registeredNotification = isNotificationRegistered(forUserID: userID)
        
        if registeredNotification.exists {
            destroyNotification(notificationID: registeredNotification.notification!)
        }
    }
}

// MARK: Private

private extension NotificationManager {
    
    private class func createNotification(forUserID userID: String, atTime: NSDate) {
        
        let localNotification = UILocalNotification()
        localNotification.userInfo = ["notificationID": userID]
        localNotification.fireDate = atTime
        localNotification.alertBody = NSLocalizedString("Check Inbbbox!", comment: "") // NGRTemp: temp text
        localNotification.alertAction = NSLocalizedString("Show", comment: "") // NGRTemp: temp text
        localNotification.repeatInterval = .Day
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    private class func destroyNotification(notificationID notificationToDelete: UILocalNotification) {
        UIApplication.sharedApplication().cancelLocalNotification(notificationToDelete)
    }
    
    private class func isNotificationRegistered(forUserID userID: String) -> (exists: Bool, notification: UILocalNotification?) {
        
        for localNotification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if let userInfo = localNotification.userInfo where localNotification.userInfo is [String: String] {
                let notificationID = userInfo["notificationID"] as! String
                if notificationID == userID {
                    return (true, localNotification)
                }
            }
        }
        return (false, nil)
    }
}
