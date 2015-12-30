//
//  SettingsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

class SettingsViewController: UIViewController {
    
    private weak var aView: GroupedBaseTableView?
    private let viewModel = SettingsViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        title = viewModel.title
    }
    
    @available(*, unavailable, message="Use init() instead")
    override init(nibName: String?, bundle: NSBundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    @available(*, unavailable, message="Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(GroupedBaseTableView.self)
        aView?.tableView.tableHeaderView = SettingsTableHeaderView(size: CGSize (width: CGRectGetWidth(aView!.bounds), height: 250))
        aView?.tableView.backgroundColor = UIColor.backgroundGrayColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupBarButtons()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.translucent = true
    }
}

// MARK: ModelUpdatable

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

// MARK: UITableViewDataSource

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

// MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = viewModel[indexPath.section][indexPath.row]
        
        if let item = item as? SwitchItem, cell = cell as? SwitchCell {
            item.bindSwitchControl(cell.switchControl)
        } else if let item = item as? SegmentedItem, cell = cell as? SegmentedCell {
            item.bindSegmentedControl(cell.segmentedControl)
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellIndexPath = tableView.indexPathForCell(cell) ?? indexPath
        let section = cellIndexPath.section
        let row = cellIndexPath.row
        
        if row < viewModel[section].count {
            let item = viewModel[section][row]
            
            if let item = item as? SwitchItem where cell is SwitchCell {
                item.unbindSwitchControl()
            } else if let item = item as? SegmentedItem where cell is SegmentedCell {
                item.unbindSegmentedControl()
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("NOTIFICATIONS", comment: "")
        case 1: return NSLocalizedString("INBBBOX STREAM SOURCE", comment: "")
        default: return ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = viewModel[indexPath.section][indexPath.row]
        
        if let item = item as? DateItem {
            navigationController?.pushViewController(DatePickerViewController(date: item.date, completion: { date -> Void in
                item.date = date
                item.update()
                self.didChangeItemsAtIndexPaths([indexPath])
            }), animated: true)
        }
        tableView.deselectRowIfSelectedAnimated(true)
    }
}

// MARK: Configure cells

private extension SettingsViewController {
    
    func configureSettingCell(cell: UITableViewCell, forItem item: GroupItem) {
        if let item = item as? SwitchItem {
            configureSwitchCell(cell as! SwitchCell, forItem: item)
        } else if let item = item as? DateItem {
            configureDateCell(cell as! DateCell, forItem: item)
        } else if let item = item as? SegmentedItem {
            configureSegmentedCell(cell as! SegmentedCell, forItem: item)
        }
    }
    
    func configureSwitchCell(cell: SwitchCell, forItem item: SwitchItem) {
        cell.textLabel?.text = item.title
        cell.switchControl.on = item.on
        cell.selectionStyle = .None
    }
    
    func configureDateCell(cell: DateCell, forItem item: DateItem) {
        cell.textLabel?.text = item.title
        cell.setDateText(item.dateString)
    }
    
    func configureSegmentedCell(cell: SegmentedCell, forItem item: SegmentedItem) {
        cell.textLabel?.text = item.title
        cell.selectionStyle = .None
        
        Async.main(after: 0.2) {
            cell.clearSelection()
        }
    }
}

// MARK: Configuration

private extension SettingsViewController {
    
    func setupTableView() {
        let tableView = aView!.tableView
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(SwitchCell.self)
        tableView.registerClass(DateCell.self)
        tableView.registerClass(SegmentedCell.self)
    }
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Log Out", comment: ""), style: .Plain, target: self, action: "didTapLogOutButton:")
    }
}

// MARK: Actions

extension SettingsViewController {
    
    func didTapLogOutButton(_: UIBarButtonItem) {
        // NGRTodo: implement me!
    }
}

private extension UITableView {
    
    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell {
        
        switch category {
        case .Date: return dequeueReusableCell(DateCell.self)
        case .Boolean: return dequeueReusableCell(SwitchCell.self)
        case .Segmented: return dequeueReusableCell(SegmentedCell.self)
        }
    }
}
