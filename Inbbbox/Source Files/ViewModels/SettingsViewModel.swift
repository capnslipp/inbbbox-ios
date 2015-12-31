//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class SettingsViewModel: GroupedListViewModel {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var title = NSLocalizedString("Account", comment: "")
    
    private weak var delegate: ModelUpdatable?
    
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem
    private let minimumLikesItem: SegmentedItem
    
    private enum Key: String {
        case ReminderOn = "ReminderOn"
        case ReminderDate = "ReminderDate"
    }
    
    // NGRTemp: should be moved to other class/enum
    private let FollowingStreamSourceKey = "FollowingStreamSourceKey"
    private let NewTodayStreamSourceOnKey = "NewTodayStreamSourceOnKey"
    private let PopularTodayStreamSourceOnKey = "PopularTodayStreamSourceOnKey"
    private let DebutsStreamSourceOnKey = "DebutsStreamSourceOnKey"
    private let MinimumLikesValueKey = "MinimumLikesValueKey"
    
    init(delegate: ModelUpdatable) {
        
        // MARK: Parameters
        
        self.delegate = delegate
        
        let reminderTitle = NSLocalizedString("Enable daily reminder", comment: "")
        let reminderDateTitle = NSLocalizedString("Send daily reminder at", comment: "")
        
        let followingStreamSourceTitle = NSLocalizedString("Following", comment: "")
        let newTodayStreamSourceTitle = NSLocalizedString("New Today", comment: "")
        let popularTodayStreamSourceTitle = NSLocalizedString("Popular Today", comment: "")
        let debutsStreamSourceTitle = NSLocalizedString("Debuts", comment: "")
        let minimumLikesTitle = NSLocalizedString("Minimum Likes", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle, on: defaults.boolForKey(Key.ReminderOn.rawValue))
        reminderDateItem = DateItem(title: reminderDateTitle, date: defaults.objectForKey(Key.ReminderDate.rawValue) as? NSDate)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: defaults.boolForKey(FollowingStreamSourceKey))
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: defaults.boolForKey(NewTodayStreamSourceOnKey))
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: defaults.boolForKey(PopularTodayStreamSourceOnKey))
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: defaults.boolForKey(DebutsStreamSourceOnKey))
        minimumLikesItem = SegmentedItem(title: minimumLikesTitle, currentValue: defaults.integerForKey(MinimumLikesValueKey))
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem, minimumLikesItem]
        ] as [[GroupItem]])
        
        // MARK: onValueChanged blocks
        
        reminderItem.onValueChanged = { on in
            // NGRTodo: make reminderDateCell active
            if on {
                NotificationManager.registerNotification(forUserID: "userID", time: self.reminderDateItem.date) //NGRTemp: provide userID
            } else {
                NotificationManager.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
            }
            self.defaults.setBool(on, forKey: Key.ReminderOn.rawValue)
        }
        
        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                NotificationManager.registerNotification(forUserID: "userID", time: date) //NGRTemp: provide userID
            }
            self.defaults.setObject(date, forKey: Key.ReminderDate.rawValue)
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            self.defaults.setBool(on, forKey: self.FollowingStreamSourceKey)
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            self.defaults.setBool(on, forKey: self.NewTodayStreamSourceOnKey)
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            self.defaults.setBool(on, forKey: self.PopularTodayStreamSourceOnKey)
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            self.defaults.setBool(on, forKey: self.DebutsStreamSourceOnKey)
        }
        
        minimumLikesItem.onValueChange = { selectedSegmentIndex -> Void in
            // NGRTodo: add likes number & update label
            switch selectedSegmentIndex {
                case 0: self.minimumLikesItem.decreaseValue()
                case 1: self.minimumLikesItem.increaseValue()
                default: break
            }
            
            self.minimumLikesItem.update()
            
            if let indexPaths = self.indexPathsForItems([self.minimumLikesItem]) {
                self.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
            
            self.defaults.setInteger(self.minimumLikesItem.currentValue, forKey: self.MinimumLikesValueKey)
        }
    }
}
