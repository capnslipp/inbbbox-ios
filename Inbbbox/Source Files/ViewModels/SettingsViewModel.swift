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
    
    var delegate: ModelUpdatable?
    var title: String
    
    let reminderItem: SwitchItem
    let reminderDateItem: DateItem
    let followingStreamSourceItem: SwitchItem
    let newTodayStreamSourceItem: SwitchItem
    let popularTodayStreamSourceItem: SwitchItem
    let debutsStreamSourceItem: SwitchItem
    let minimumLikesItem: SegmentedItem
    let logOutButtonItem: ButtonItem
    
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
        let logOutTitle = NSLocalizedString("Log out", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle)
        reminderDateItem = DateItem(title: reminderDateTitle)
        
        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle)
        minimumLikesItem = SegmentedItem(title: minimumLikesTitle, currentValue: 0)
        logOutButtonItem = ButtonItem(title: logOutTitle)
        
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem, minimumLikesItem],
            [logOutButtonItem]
            ] as [[GroupItem]])
        
        // MARK: onValueChanged and onButtonTapped blocks
        
        reminderItem.onValueChanged = { on in
            // NGRTodo: make reminderDateCell active
            if on {
                NotificationManager.registerNotification(forUserID: "userID", time: self.reminderDateItem.date) //NGRTemp: provide userID
            } else {
                NotificationManager.unregisterNotification(forUserID: "userID") //NGRTemp: provide userID
            }
        }
        
        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                NotificationManager.registerNotification(forUserID: "userID", time: date) //NGRTemp: provide userID
            }
        }
        
        followingStreamSourceItem.onValueChanged = { on in
            _ = on ? true : false // NGRTodo: implement me!
        }
        
        newTodayStreamSourceItem.onValueChanged = { on in
            _ = on ? true : false // NGRTodo: implement me!
        }
        
        popularTodayStreamSourceItem.onValueChanged = { on in
            _ = on ? true : false // NGRTodo: implement me!
        }
        
        debutsStreamSourceItem.onValueChanged = { on in
            _ = on ? true : false // NGRTodo: implement me!
        }
        
        minimumLikesItem.onValueChange = { selectedSegmentIndex -> Void in
            // NGRTodo: add likes number & update label
            switch selectedSegmentIndex {
                case 0: self.minimumLikesItem.decreaseValue()
                case 1: self.minimumLikesItem.increaseValue()
                default: break
            }
            
//            self.minimumLikesItem.clearSelection()
            
            self.minimumLikesItem.update()
            
            if let indexPaths = self.indexPathsForItems([self.minimumLikesItem]) {
                self.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
        
        
        
        logOutButtonItem.onButtonTapped = { _ -> Void in
            // NGRTodo: log out or pass info that user wants to log out
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
