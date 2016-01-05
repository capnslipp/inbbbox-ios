//
//  DefaultsWrapper.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class DefaultsWrapper {
    
    class var ReminderEnabled: Bool? {
        get {
            return Defaults[DefaultsKey.ReminderOn.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.ReminderOn.rawValue] = newValue
        }
    }
    
    class var ReminderDate: NSDate? {
        get {
            return Defaults[DefaultsKey.ReminderDate.rawValue].date
        }
        set {
            Defaults[DefaultsKey.ReminderDate.rawValue] = newValue
        }
    }
    
    class var ShouldIncludeFollowingStreamSource: Bool? {
        get {
            return Defaults[DefaultsKey.FollowingStreamSourceOn.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.FollowingStreamSourceOn.rawValue] = newValue
        }
    }
    
    class var ShouldIncludeNewTodayStreamSource: Bool? {
        get {
            return Defaults[DefaultsKey.NewTodayStreamSourceOn.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.NewTodayStreamSourceOn.rawValue] = newValue
        }
    }
    
    class var ShouldIncludePopularTodayStreamSource: Bool? {
        get {
            return Defaults[DefaultsKey.PopularTodayStreamSourceOn.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.PopularTodayStreamSourceOn.rawValue] = newValue
        }
    }
    
    class var ShouldIncludeDebutsStreamSource: Bool? {
        get {
            return Defaults[DefaultsKey.DebutsStreamSourceOn.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.DebutsStreamSourceOn.rawValue] = newValue
        }
    }
    
    class var LocalNotificationSettingsProvided: Bool? {
        get {
            return Defaults[DefaultsKey.LocalNotificationSettingsProvided.rawValue].bool
        }
        set {
            Defaults[DefaultsKey.LocalNotificationSettingsProvided.rawValue] = newValue
        }
    }
}
