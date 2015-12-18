//
//  SettingsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import UIKit

class SettingsViewController: UIViewController {
    
    private weak var aView: GroupedBaseTableView?
    private var viewModel: SettingsViewModel!
    
    init() {
        self.viewModel = SettingsViewModel()
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.title = self.viewModel.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(GroupedBaseTableView.self)
        aView?.tableView.tableHeaderView = SettingsTableHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTableView()
    }
}

// MARK ModelUpdatable

extension SettingsViewController: ModelUpdatable {
    
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            if let cell = aView?.tableView.cellForRowAtIndexPath(indexPath) {
                let item = viewModel[indexPath.section][indexPath.row]
                configureSettingCell(cell, forItem: item)
            }
        }
    }
    
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        aView?.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        aView?.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
    }
}

// MARK UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = viewModel[indexPath.section][indexPath.row]
        let cell = tableView.cellForItemCategory(item.category)
        
        configureSettingCell(cell, forItem: item)
        
        return cell ?? UITableViewCell()
    }
}

// MARK UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = viewModel[indexPath.section][indexPath.row]
        
        if let item = item as? DatePickerItem, cell = cell as? DatePickerCell {
            item.bindDatePicker(cell.datePicker)
        } else if let item = item as? SwitchItem, cell = cell as? SwitchCell {
            item.bindSwitchControl(cell.switchControl)
        } else if let item = item as? ButtonItem, cell = cell as? ButtonCell {
            item.bindButtonControl(cell.buttonControl)
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellIndexPath = tableView.indexPathForCell(cell) ?? indexPath
        let section = cellIndexPath.section
        let row = cellIndexPath.row
        
        if row < viewModel[section].count {
            let item = viewModel[section][row]
            
            if let item = item as? SwitchItem, _ = cell as? SwitchCell {
                item.unbindSwitchControl()
            } else if let item = item as? DatePickerItem, _ = cell as? DatePickerCell {
                item.unbindDatePicker()
            } else if let item = item as? ButtonItem, _ = cell as? ButtonCell {
                item.unbindButtonControl()
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? NSLocalizedString("Notifications", comment: "") : ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.handleSelectionAtIndexPath(indexPath)
        tableView.deselectRowIfSelectedAnimated(true)
    }
}

// MARK Configure cells

private extension SettingsViewController {
    
    func configureSettingCell(cell: UITableViewCell, forItem item: GroupItem) {
        if let item = item as? SwitchItem {
            configureSwitchCell(cell as! SwitchCell, forItem: item)
        } else if let item = item as? DateItem {
            configureDateCell(cell as! DateCell, forItem: item)
        } else if let item = item as? DatePickerItem {
            configureDatePickerCell(cell as! DatePickerCell, forItem: item)
        } else if let item = item as? ButtonItem {
            configureButtonCell(cell as! ButtonCell, forItem: item)
        }
    }
    
    func configureSwitchCell(cell: SwitchCell, forItem item: SwitchItem) {
        cell.textLabel?.text = item.title
        cell.selectionStyle = .None
    }
    
    func configureDateCell(cell: DateCell, forItem item: DateItem) {
        cell.textLabel?.text = item.title
        cell.setDateText(item.dateString, withValidationError: item.validationError)
        cell.shouldBeGreyedOut = !item.active
    }
    
    func configureDatePickerCell(cell: DatePickerCell, forItem item: DatePickerItem) {
        cell.selectionStyle = .None
    }
    
    func configureButtonCell(cell: ButtonCell, forItem item: ButtonItem) {
        cell.buttonControl.titleLabel?.text = item.title
        cell.selectionStyle = .None
    }
}

// MARK: Private

private extension SettingsViewController {
    
    // MARK: Configuration
    
    func setupTableView() {
        let tableView = aView!.tableView
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(SwitchCell.self)
        tableView.registerClass(DateCell.self)
        tableView.registerClass(ButtonCell.self)
        
    }
    
    func setupBarButtons() {
        // NGRTodo: implement me!
    }
}

private extension UITableView {
    
    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell {
        
        switch category {
        case .Date: return dequeueReusableCell(DateCell.self)
        case .Picker: return dequeueReusableCell(DatePickerCell.self)
        case .Action: return dequeueReusableCell(ButtonCell.self)
        case .Boolean: return dequeueReusableCell(SwitchCell.self)
        default: return UITableViewCell()
        }
    }
}
