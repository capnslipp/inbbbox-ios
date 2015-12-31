//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import SwiftyUserDefaults

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath])
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
    
    private enum Key: String {
        case ReminderOn = "ReminderOn"
        case ReminderDate = "ReminderDate"
    }
    
    // NGRTemp: should be moved to other class/enum
    private let FollowingStreamSourceOnKey = "FollowingStreamSourceKey"
    private let NewTodayStreamSourceOnKey = "NewTodayStreamSourceOnKey"
    private let PopularTodayStreamSourceOnKey = "PopularTodayStreamSourceOnKey"
    private let DebutsStreamSourceOnKey = "DebutsStreamSourceOnKey"
    
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
        
        reminderItem = SwitchItem(title: reminderTitle, on: Defaults[Key.ReminderOn.rawValue].bool)
        reminderDateItem = DateItem(title: reminderDateTitle, date: Defaults[Key.ReminderDate.rawValue].date)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: Defaults[FollowingStreamSourceOnKey].bool)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: Defaults[NewTodayStreamSourceOnKey].bool)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: Defaults[PopularTodayStreamSourceOnKey].bool)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: Defaults[DebutsStreamSourceOnKey].bool)
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem]
        ] as [[GroupItem]])
        
        // MARK: onValueChanged blocks
        
        reminderItem.onValueChanged = { on in
            // NGRTodo: make reminderDateCell active
            if on {
                NotificationManager.registerNotification(forUserID: "userID", time: self.reminderDateItem.date) //NGRTemp: provide userID
            } else {
                NotificationManager.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
            }
            Defaults[Key.ReminderOn.rawValue] = on
        }
        
        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                NotificationManager.registerNotification(forUserID: "userID", time: date) //NGRTemp: provide userID
            }
            Defaults[Key.ReminderDate.rawValue] = date
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            Defaults[self.FollowingStreamSourceOnKey] = on
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            Defaults[self.NewTodayStreamSourceOnKey] = on
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            Defaults[self.PopularTodayStreamSourceOnKey] = on
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            Defaults[self.DebutsStreamSourceOnKey] = on
        }
    }
}
