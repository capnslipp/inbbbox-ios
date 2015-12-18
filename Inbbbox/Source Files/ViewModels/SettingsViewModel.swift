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
    let logOutButtonItem: ButtonItem
    
    init() {
        
        // MARK: Parameters
        
        title = NSLocalizedString("Account", comment: "")
        
        let reminderTitle = NSLocalizedString("Enable daily reminder", comment: "")
        let reminderDateTitle = NSLocalizedString("Send daily reminder at", comment: "")
        let logOutTitle = NSLocalizedString("Log out", comment: "")
        
        // MARK: Create items
        
        reminderItem = SwitchItem(title: reminderTitle)
        reminderDateItem = DateItem(title: reminderDateTitle)
        logOutButtonItem = ButtonItem(title: logOutTitle)
        
        // MARK: Super init
        
        super.init(items: [
            [reminderItem, reminderDateItem],
            [logOutButtonItem]
            ] as [[GroupItem]])
        
        // MARK: onValueChanged and onButtonTapped blocks
        
        reminderItem.onValueChanged = { [weak self] text in
            // NGRTodo: make reminderDateCell active or not and setup notification on/off
        }
        
        reminderDateItem.onValueChanged = {date -> Void in
            // NGRTodo: plan notifications?
        }
        
        logOutButtonItem.onButtonTapped = { _ -> Void in
            // NGRTodo: log out or pass info that user want to log out
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
