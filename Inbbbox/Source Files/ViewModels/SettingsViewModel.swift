//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ModelUpdatable {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class SettingsViewModel: GroupedListViewModel {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var delegate: ModelUpdatable?
    var title: String
    
    let reminderItem: SwitchItem
    let reminderDateItem: DateItem
    let followingStreamSourceItem: SwitchItem
    let newTodayStreamSourceItem: SwitchItem
    let popularTodayStreamSourceItem: SwitchItem
    let debutsStreamSourceItem: SwitchItem
    let minimumLikesItem: SegmentedItem
    
    private let ReminderOnKey = "ReminderOnKey"
    private let ReminderDateKey = "ReminderDateKey"
    
    // NGRTemp: should be moved to other class/NSStringExtension
    private let FollowingStreamSourceKey = "FollowingStreamSourceKey"
    private let NewTodayStreamSourceOnKey = "NewTodayStreamSourceOnKey"
    private let PopularTodayStreamSourceOnKey = "PopularTodayStreamSourceOnKey"
    private let DebutsStreamSourceOnKey = "DebutsStreamSourceOnKey"
    private let MinimumLikesValueKey = "MinimumLikesValueKey"
    
    init() {
        
        // MARK: Parameters
        
        title = NSLocalizedString("Account", comment: "")
        
        let reminderTitle = NSLocalizedString("Enable daily reminder", comment: "")
        let reminderDateTitle = NSLocalizedString("Send daily reminder at", comment: "")
        
        let followingStreamSourceTitle = NSLocalizedString("Following", comment: "")
        let newTodayStreamSourceTitle = NSLocalizedString("New Today", comment: "")
        let popularTodayStreamSourceTitle = NSLocalizedString("Popular Today", comment: "")
        let debutsStreamSourceTitle = NSLocalizedString("Debuts", comment: "")
        let minimumLikesTitle = NSLocalizedString("Minimum Likes", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle, on: defaults.boolForKey(ReminderOnKey))
        reminderDateItem = DateItem(title: reminderDateTitle, date: defaults.objectForKey(ReminderDateKey) as? NSDate)
        
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
        
        // MARK: onValueChanged and onButtonTapped blocks
        
        reminderItem.onValueChanged = { on in
            // NGRTodo: make reminderDateCell active
            if on {
                NotificationManager.registerNotification(forUserID: "userID", time: self.reminderDateItem.date) //NGRTemp: provide userID
            } else {
                NotificationManager.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
            }
            self.defaults.setBool(on, forKey: self.ReminderOnKey)
        }
        
        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                NotificationManager.registerNotification(forUserID: "userID", time: date) //NGRTemp: provide userID
            }
            self.defaults.setObject(date, forKey: self.ReminderDateKey)
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

// MARK: Date pickers handling

extension SettingsViewModel {
    
    func handleSelectionAtIndexPath(indexPath: NSIndexPath) {
        let item = self[indexPath.section][indexPath.row]
        
        if let item = item as? DateItem {
            handleSelectionOfDateItem(item, atIndexPath: indexPath)
        }
    }
    
    // NGRTemp: temporary implementation
    private func handleSelectionOfDateItem(item: DateItem, atIndexPath indexPath: NSIndexPath) {
        
        var dateItems: [DateItem] = []
        let collapseIndexPaths = indexPathsForItemOfType(DatePickerItem.self)
        
        if let pickersIndexPaths = collapseIndexPaths {
            
            for pickerIndexPath in pickersIndexPaths {
                
                let section = pickerIndexPath.section
                let row = pickerIndexPath.row
                
                if let pickerItem = self[section][row] as? DatePickerItem {
                    pickerItem.unbindDatePicker()
                }
                
                removeAtIndexPath(pickerIndexPath)
                
                if let dateItem = self[section][row-1] as? DateItem {
                    dateItem.highlighted = false
                    dateItems.append(dateItem)
                }
            }
            
            delegate?.removedItemsAtIndexPaths(pickersIndexPaths)
            
            if let reloadIndexPaths = indexPathsForItems(dateItems) {
                delegate?.didChangeItemsAtIndexPaths(reloadIndexPaths)
            }
        }
        
        if !item.highlighted && !dateItems.contains(item) {
            
            item.highlighted = true
            
            let pickerItem = datePickerItemForDateItem(item)
            
            if var currentIndexPath = indexPathsForItems([item])?.first {
                currentIndexPath = NSIndexPath(forRow: currentIndexPath.row+1, inSection: currentIndexPath.section)
                addItem(pickerItem, atIndexPath: currentIndexPath)
                delegate?.addedItemsAtIndexPaths([currentIndexPath])
            }
        }
    }
    
    private func datePickerItemForDateItem(item: DateItem) -> DatePickerItem {
        return DatePickerItem(date: item.date) { [weak self] date in
            item.date = date
            item.update()
            
            if let indexPaths = self?.indexPathsForItems([item]) {
                self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
    }
}
