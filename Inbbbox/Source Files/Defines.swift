//
//  Defines.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum NotificationKey: String {
    case UserNotificationSettingsRegistered = "UserNotificationSettingsRegistered"
}

enum DefaultsKey: String {
    case ReminderOn = "ReminderOn"
    case ReminderDate = "ReminderDate"
    case FollowingStreamSourceOn = "FollowingStreamSourceOn"
    case NewTodayStreamSourceOn = "NewTodayStreamSourceOn"
    case PopularTodayStreamSourceOn = "PopularTodayStreamSourceOn"
    case DebutsStreamSourceOn = "DebutsStreamSourceOn"
    case LocalNotificationSettingsProvided = "LocalNotificationSettingsProvided"
}
