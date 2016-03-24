//
//  Defines.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum NotificationKey: String {
    case ReminderOn = "ReminderOn"
    case ReminderDate = "ReminderDate"
    case UserNotificationSettingsRegistered = "UserNotificationSettingsRegistered"
    case LocalNotificationSettingsProvided = "LocalNotificationSettingsProvided"
}

enum StreamSourceKey: String {
    case StreamSourceIsSet = "StreamSourceIsSet"
    case FollowingStreamSourceOn = "FollowingStreamSourceOn"
    case NewTodayStreamSourceOn = "NewTodayStreamSourceOn"
    case PopularTodayStreamSourceOn = "PopularTodayStreamSourceOn"
    case DebutsStreamSourceOn = "DebutsStreamSourceOn"
}

enum InbbboxNotificationKey: String {
    case UserDidChangeStreamSourceSettings
    case UserDidChangeNotificationsSettings
}
