//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

protocol AlertDisplayable: class {
    func displayAlert(alert: UIAlertController)
}

class SettingsViewModel: GroupedListViewModel {
    
    let title = NSLocalizedString("Account", comment: "")
    
    private weak var delegate: ModelUpdatable?
    private weak var alertDelegate: AlertDisplayable?
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem
    
    var loggedInUser: User? {
        return UserStorage.currentUser
    }
    
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
        
        reminderItem = SwitchItem(title: reminderTitle, on: Settings.Reminder.Enabled)
        reminderDateItem = DateItem(title: reminderDateTitle, date: Settings.Reminder.Date)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: Settings.StreamSource.Following)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: Settings.StreamSource.NewToday)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: Settings.StreamSource.PopularToday)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: Settings.StreamSource.Debuts)
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem]
        ] as [[GroupItem]])
        
        // MARK: onValueChanged blocks
        
        reminderItem.onValueChanged = { on in
            Settings.Reminder.Enabled = on
            if on {
                self.registerUserNotificationSettings()
                
                if Settings.Reminder.LocalNotificationSettingsProvided == true {
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
            Settings.Reminder.Date = date
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.Following = on
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.NewToday = on
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.PopularToday = on
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.Debuts = on
        }
        
        // MARK: add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didProvideNotificationSettings", name: NotificationKey.UserNotificationSettingsRegistered.rawValue, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    dynamic func didProvideNotificationSettings() {
        Settings.Reminder.LocalNotificationSettingsProvided = true
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
            Settings.Reminder.Enabled = false
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
