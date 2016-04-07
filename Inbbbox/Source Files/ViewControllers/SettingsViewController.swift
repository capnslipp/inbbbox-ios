//
//  SettingsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class SettingsViewController: UITableViewController {

    private var viewModel: SettingsViewModel!

    convenience init() {
        self.init(style: UITableViewStyle.Grouped)
        viewModel = SettingsViewModel(delegate: self)
        viewModel.settingsViewController = self
        title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoutButton()

        tableView.registerClass(SwitchCell.self)
        tableView.registerClass(DateCell.self)
        tableView.registerClass(LabelCell.self)

        tableView?.hideSeparatorForEmptyCells()
        tableView?.backgroundColor = UIColor.backgroundGrayColor()
        tableView?.tableHeaderView = SettingsTableHeaderView(size: CGSize (width: 0, height: 250))

        provideDataForHeader()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshViewAccordingToAuthenticationStatus()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsManager.trackScreen(.SettingsView)
    }
}

// MARK: ModelUpdatable

extension SettingsViewController: ModelUpdatable {

    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        indexPaths.forEach {
            if let cell = tableView?.cellForRowAtIndexPath($0) {
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

extension SettingsViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = viewModel[indexPath.section][indexPath.row]
        let cell = tableView.cellForItemCategory(item.category)

        configureSettingCell(cell, forItem: item)

        return cell ?? UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension SettingsViewController {

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = viewModel[indexPath.section][indexPath.row]

        if let item = item as? SwitchItem, cell = cell as? SwitchCell {
            item.bindSwitchControl(cell.switchControl)
        }
    }

    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellIndexPath = tableView.indexPathForCell(cell) ?? indexPath
        let section = cellIndexPath.section
        let row = cellIndexPath.row
        if section < viewModel.sectionsCount() && row < viewModel[section].count {
            let item = viewModel[section][row]

            if let item = item as? SwitchItem where cell is SwitchCell {
                item.unbindSwitchControl()
            }
        }

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let notificationsTitle = NSLocalizedString("NOTIFICATIONS", comment: "")
        let streamSourcesTitle = NSLocalizedString("INBBBOX STREAM SOURCE", comment: "")

        switch section {
            case 0: return viewModel.userMode == .LoggedUser ? notificationsTitle : nil
            case 1: return viewModel.userMode == .LoggedUser ? streamSourcesTitle : notificationsTitle
            case 2: return viewModel.userMode == .LoggedUser ? nil : streamSourcesTitle
            default: return nil
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let item = viewModel[indexPath.section][indexPath.row]

        if let item = item as? DateItem {

            let completion: (NSDate -> Void) = { date in
                item.date = date
                item.update()
                self.didChangeItemsAtIndexPaths([indexPath])
            }

            navigationController?.pushViewController(DatePickerViewController(date: item.date, completion: completion), animated: true)
        }
        if let labelItem = item as? LabelItem {
            labelItem.onSelect?()
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
        } else if let item = item as? LabelItem {
            configureLabelCell(cell as! LabelCell, forItem: item)
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

    func configureLabelCell(cell: LabelCell, forItem item: LabelItem) {
        cell.titleLabel.text = item.title
    }

}

// MARK: Configuration

private extension SettingsViewController {

    func configureLogoutButton() {
        navigationItem.rightBarButtonItem = viewModel.loggedInUser != nil ? UIBarButtonItem(
            title: NSLocalizedString("Log Out", comment: ""),
            style: .Plain,
            target: self,
            action: "didTapLogOutButton:"
        ) : nil
    }

    func provideDataForHeader() {

        guard let header = tableView?.tableHeaderView as? SettingsTableHeaderView else {
            return
        }
        if let user = viewModel.loggedInUser {
            header.usernameLabel.text = user.name ?? user.username
        } else {
            header.usernameLabel.text = NSLocalizedString("Guest?", comment: "")
        }
        header.avatarView.imageView.loadImageFromURL(viewModel.loggedInUser?.avatarURL, placeholderImage: UIImage(named: "avatar_placeholder"))
    }
}

// MARK: Authentication

extension SettingsViewController {

    func authenticateUser() {
        let interactionHandler: (UIViewController -> Void) = { controller in
            self.presentViewController(controller, animated: true, completion: nil)
        }
        let authenticator = Authenticator(interactionHandler: interactionHandler)

        firstly {
            authenticator.loginWithService(.Dribbble)
        }.then { result -> Void in
            self.refreshViewAccordingToAuthenticationStatus()
        }
    }

    func refreshViewAccordingToAuthenticationStatus() {
        let userMode = UserStorage.isUserSignedIn ? UserMode.LoggedUser : .DemoUser
        if userMode != viewModel.userMode {
            viewModel = SettingsViewModel(delegate: self)
            provideDataForHeader()
            tableView.reloadData()
            configureLogoutButton()
        }
    }
}

// MARK: Actions

extension SettingsViewController {

    func didTapLogOutButton(_: UIBarButtonItem) {
        Authenticator.logout()
        UIApplication.sharedApplication().keyWindow?.setRootViewController(LoginViewController(), transition: nil)
    }

    func presentAcknowledgements() {
        let acknowledgementsNavigationController = UINavigationController(rootViewController: AcknowledgementsViewController())
        presentViewController(acknowledgementsNavigationController, animated: true, completion: nil)
    }
}

private extension UITableView {

    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell {

        switch category {
            case .Date: return dequeueReusableCell(DateCell)
            case .Boolean: return dequeueReusableCell(SwitchCell)
            case .String: return dequeueReusableCell(LabelCell)
        }
    }
}
