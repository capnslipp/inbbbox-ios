//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class SettingsViewModel: GroupedListViewModel {

    var title = NSLocalizedString("Account", comment: "")
    
    private weak var delegate: ModelUpdatable?
    
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem
    
    init(delegate: ModelUpdatable) {
        
        // MARK: Parameters
        
        self.delegate = delegate
        
        let reminderTitle = NSLocalizedString("Enable daily reminder", comment: "")
        let reminderDateTitle = NSLocalizedString("Send daily reminder at", comment: "")
        
        let followingStreamSourceTitle = NSLocalizedString("Following", comment: "")
        let newTodayStreamSourceTitle = NSLocalizedString("New Today", comment: "")
        let popularTodayStreamSourceTitle = NSLocalizedString("Popular Today", comment: "")
        let debutsStreamSourceTitle = NSLocalizedString("Debuts", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle, on: ReminderEnabled)
        reminderDateItem = DateItem(title: reminderDateTitle, date: ReminderDate)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: ShouldIncludeFollowingStreamSource)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: ShouldIncludeNewTodayStreamSource)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: ShouldIncludePopularTodayStreamSource)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: ShouldIncludeDebutsStreamSource)
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem]
        ] as [[GroupItem]])
        
        // MARK: onValueChanged blocks
        
        reminderItem.onValueChanged = { on in
            ReminderEnabled = on
            if on {
                self.registerUserNotificationSettings()
                
                if LocalNotificationSettingsProvided == true {
                    self.registerLocalNotification()
                }
            } else {
                self.unregisterLocalNotification()
            }
        }
        
        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                self.registerLocalNotification()
            }
            ReminderDate = date
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            ShouldIncludeFollowingStreamSource = on
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            ShouldIncludeNewTodayStreamSource = on
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            ShouldIncludePopularTodayStreamSource = on
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            ShouldIncludeDebutsStreamSource = on
        }
        
        // MARK: add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didProvideNotificationSettings", name: NotificationKey.UserNotificationSettingsRegistered.rawValue, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    dynamic func didProvideNotificationSettings() {
        LocalNotificationSettingsProvided = true
        registerLocalNotification()
    }
}

// MARK: Private extension

private extension SettingsViewModel {
    
    func registerUserNotificationSettings() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
    }
    
    func registerLocalNotification() {
        
        let localNotification = LocalNotificationRegistrator.registerNotification(forUserID: "userID", time: reminderDateItem.date) //NGRTemp: provide userID
        
        if localNotification == nil {
            // NGRTodo: display alert and redirect to settings
            reminderItem.on = false
            ReminderEnabled = false
            delegate?.didChangeItemsAtIndexPaths(indexPathsForItems([reminderItem])!)
        }
    }
    
    func unregisterLocalNotification() {
        LocalNotificationRegistrator.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
    }
}
