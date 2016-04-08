//
//  Settings.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

/// Provides interface for application settings kept in user defaults.
class Settings {
    
    /// Manages settings related to streams' sources.
    struct StreamSource {
        
        /// Indicates if streams' sources are initially set.
        static var IsSet: Bool {
            get { return Settings.boolForKey(.StreamSourceIsSet) }
            set { Settings.setValue(newValue, forKey: .StreamSourceIsSet) }
        }
        
        /// Indicates if stream's source for Following is on.
        static var Following: Bool {
            get { return Settings.boolForKey(.FollowingStreamSourceOn) }
            set { Settings.setValue(newValue, forKey: .FollowingStreamSourceOn) }
        }
        
        /// Indicates if stream's source for NewToday is on.
        static var NewToday: Bool {
            get { return Settings.boolForKey(.NewTodayStreamSourceOn) }
            set { Settings.setValue(newValue, forKey: .NewTodayStreamSourceOn) }
        }
        
        /// Indicates if stream's source for PopularToday is on.
        static var PopularToday: Bool {
            get { return Settings.boolForKey(.PopularTodayStreamSourceOn) }
            set { Settings.setValue(newValue, forKey: .PopularTodayStreamSourceOn) }
        }
        
        /// Indicates if stream's source for Debuts is on.
        static var Debuts: Bool {
            get { return Settings.boolForKey(.DebutsStreamSourceOn) }
            set { Settings.setValue(newValue, forKey: .DebutsStreamSourceOn) }
        }
    }
    
    /// Manages settings related to reminder.
    struct Reminder {
        
        /// Indicates if reminder is enabled.
        static var Enabled: Bool {
            get { return Settings.boolForKey(.ReminderOn) }
            set { Settings.setValue(newValue, forKey: .ReminderOn) }
        }
        
        /// Indicates date that reminder should appear.
        static var Date: NSDate? {
            get { return Settings.dateForKey(.ReminderDate) }
            set { Settings.setValue(newValue, forKey: .ReminderDate) }
        }
        
        /// Indicates if settings for local notifications are provided.
        static var LocalNotificationSettingsProvided: Bool {
            get { return Settings.boolForKey(.LocalNotificationSettingsProvided) }
            set { Settings.setValue(newValue, forKey: .LocalNotificationSettingsProvided) }
        }
    }
}

private extension Settings {
    
    // MARK: NotificationKey
    
    static func boolForKey(key: NotificationKey) -> Bool {
        return boolForKey(key.rawValue)
    }
    
    static func dateForKey(key: NotificationKey) -> NSDate? {
        return Defaults[key.rawValue].date
    }
    
    static func setValue(value: AnyObject?, forKey key: NotificationKey) {
        Defaults[key.rawValue] = value
        NSNotificationCenter.defaultCenter().postNotificationName(InbbboxNotificationKey.UserDidChangeNotificationsSettings.rawValue, object: self)
    }
    
    // MARK: StreamSourceKey
    
    static func boolForKey(key: StreamSourceKey) -> Bool {
        return boolForKey(key.rawValue)
    }
    
    static func setValue(value: AnyObject?, forKey key: StreamSourceKey) {
        Defaults[key.rawValue] = value
        NSNotificationCenter.defaultCenter().postNotificationName(InbbboxNotificationKey.UserDidChangeStreamSourceSettings.rawValue, object: self)
    }
    
    // MARK: General
    
    static func boolForKey(key: String) -> Bool {
        return Defaults[key].bool ?? false
    }
}
