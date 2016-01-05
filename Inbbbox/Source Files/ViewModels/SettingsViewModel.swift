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

protocol AlertDisplayable: class {
    func displayAlert(alert: UIAlertController)
}

class SettingsViewModel: GroupedListViewModel {

    var title = NSLocalizedString("Account", comment: "")
    
    private weak var delegate: ModelUpdatable?
    private weak var alertDelegate: AlertDisplayable?
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem
    
    init(delegate: ModelUpdatable) {
        
        // MARK: Parameters
        
        self.delegate = delegate
        self.alertDelegate = delegate as? AlertDisplayable
        
        let reminderTitle = NSLocalizedString("Enable daily reminder", comment: "")
        let reminderDateTitle = NSLocalizedString("Send daily reminder at", comment: "")
        
        let followingStreamSourceTitle = NSLocalizedString("Following", comment: "")
        let newTodayStreamSourceTitle = NSLocalizedString("New Today", comment: "")
        let popularTodayStreamSourceTitle = NSLocalizedString("Popular Today", comment: "")
        let debutsStreamSourceTitle = NSLocalizedString("Debuts", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle, on: DefaultsWrapper.ReminderEnabled)
        reminderDateItem = DateItem(title: reminderDateTitle, date: DefaultsWrapper.ReminderDate)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: DefaultsWrapper.ShouldIncludeFollowingStreamSource)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: DefaultsWrapper.ShouldIncludeNewTodayStreamSource)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: DefaultsWrapper.ShouldIncludePopularTodayStreamSource)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: DefaultsWrapper.ShouldIncludeDebutsStreamSource)
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem]
        ] as [[GroupItem]])
        
        // MARK: onValueChanged blocks
        
        reminderItem.onValueChanged = { on in
            DefaultsWrapper.ReminderEnabled = on
            if on {
                self.registerUserNotificationSettings()
                
                if DefaultsWrapper.LocalNotificationSettingsProvided == true {
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
            DefaultsWrapper.ReminderDate = date
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            DefaultsWrapper.ShouldIncludeFollowingStreamSource = on
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            DefaultsWrapper.ShouldIncludeNewTodayStreamSource = on
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            DefaultsWrapper.ShouldIncludePopularTodayStreamSource = on
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            DefaultsWrapper.ShouldIncludeDebutsStreamSource = on
        }
        
        // MARK: add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didProvideNotificationSettings", name: NotificationKey.UserNotificationSettingsRegistered.rawValue, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    dynamic func didProvideNotificationSettings() {
        DefaultsWrapper.LocalNotificationSettingsProvided = true
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

            alertDelegate?.displayAlert(preparePermissionsAlert())
            
            reminderItem.on = false
            DefaultsWrapper.ReminderEnabled = false
            delegate?.didChangeItemsAtIndexPaths(indexPathsForItems([reminderItem])!)
        }
    }
    
    func unregisterLocalNotification() {
        LocalNotificationRegistrator.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
    }
    
    // MARK: Prepare alert
    
    func preparePermissionsAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString("Permissions", comment: ""), message: NSLocalizedString("You have to give access to notifications.", comment: ""), preferredStyle: .Alert) // NGRTemp: temporary texts
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .Default) {
            _ in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .Default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
