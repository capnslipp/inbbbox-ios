//
//  SettingsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private weak var aView: GroupedBaseTableView?
    private var viewModel: SettingsViewModel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = SettingsViewModel(delegate: self)
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
        aView?.backgroundColor = UIColor.backgroundGrayColor()
        aView?.tableView.tableHeaderView = SettingsTableHeaderView(size: CGSize (width: CGRectGetWidth(aView!.bounds), height: 250))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupBarButtons()
        setupTableView()
        provideDataForHeader()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.translucent = true
    }
}

// MARK: ModelUpdatable

extension SettingsViewController: ModelUpdatable {
    
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        indexPaths.forEach {
            if let cell = aView?.tableView.cellForRowAtIndexPath($0) {
                let item = viewModel[$0.section][$0.row]
                configureSettingCell(cell, forItem: item)
            }
        }
    }
}

extension SettingsViewController: AlertDisplayable {
    
    func displayAlert(alert: UIAlertController) {
        presentViewController(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.blackColor()
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
            
            let completion: (NSDate -> Void) = { date in
                item.date = date
                item.update()
                self.didChangeItemsAtIndexPaths([indexPath])
            }
            
            navigationController?.pushViewController(DatePickerViewController(date: item.date, completion: completion), animated: true)
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
    }
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Log Out", comment: ""), style: .Plain, target: self, action: "didTapLogOutButton:")
    }
    
    func provideDataForHeader() {
        
        guard let header = aView?.tableView.tableHeaderView as? SettingsTableHeaderView else {
            return
        }
        
        header.usernameLabel.text = viewModel.username()
        
        viewModel.fetchAvatar { image in
            header.avatarView.imageView.image = image
        }
    }
}

// MARK: Actions

extension SettingsViewController {
    
    func didTapLogOutButton(_: UIBarButtonItem) {
        Authenticator.logout()
        provideDataForHeader()
        //NGRToDo: Remember to hide settings when user is logged out
    }
}

private extension UITableView {
    
    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell {
        
        switch category {
            case .Date: return dequeueReusableCell(DateCell.self)
            case .Boolean: return dequeueReusableCell(SwitchCell.self)
        }
    }
}
