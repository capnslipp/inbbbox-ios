//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async
import AOAlertController

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

protocol AlertDisplayable: class {
    func displayAlert(alert: AOAlertController)
}

enum UserMode {
    case LoggedUser, DemoUser
}

class SettingsViewModel: GroupedListViewModel {

    let title = NSLocalizedString("SettingsViewModel.Account", comment: "Title for account screen")

    weak var settingsViewController: SettingsViewController?

    private(set) var userMode: UserMode
    private weak var delegate: ModelUpdatable?
    private weak var alertDelegate: AlertDisplayable?

    private let createAccountTitle = NSLocalizedString("SettingsViewModel.CreateAccount",
            comment: "Button text allowing user to create new account.")
    private let reminderTitle = NSLocalizedString("SettingsViewModel.EnableDailyReminders",
            comment: "User settings, enable daily reminders")
    private let reminderDateTitle = NSLocalizedString("SettingsViewModel.SendDailyReminders",
            comment: "User settings, send daily reminders")
    private let followingStreamSourceTitle = NSLocalizedString("SettingsViewModel.Following",
            comment: "User settings, enable following")
    private let newTodayStreamSourceTitle = NSLocalizedString("SettingsViewModel.NewToday",
            comment: "User settings, enable new today.")
    private let popularTodayStreamSourceTitle = NSLocalizedString("SettingsViewModel.Popular",
            comment: "User settings, enable popular today.")
    private let debutsStreamSourceTitle = NSLocalizedString("SettingsViewModel.Debuts",
            comment: "User settings, show debuts.")

    private let createAccountItem: LabelItem
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem
    private let acknowledgementItem: LabelItem

    var loggedInUser: User? {
        return UserStorage.currentUser
    }

    init(delegate: ModelUpdatable) {

        // MARK: Parameters

        self.delegate = delegate
        self.alertDelegate = delegate as? AlertDisplayable
        self.userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser

        // MARK: Create items

        createAccountItem = LabelItem(title: createAccountTitle)

        reminderItem = SwitchItem(title: reminderTitle, enabled: Settings.Reminder.Enabled)
        reminderDateItem = DateItem(title: reminderDateTitle, date: Settings.Reminder.Date)

        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle,
                enabled: Settings.StreamSource.Following)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle,
                enabled: Settings.StreamSource.NewToday)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle,
                enabled: Settings.StreamSource.PopularToday)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle,
                enabled: Settings.StreamSource.Debuts)
        acknowledgementItem = LabelItem(title: NSLocalizedString("SettingsViewModel.AcknowledgementsButton",
                comment: "Acknowledgements button"))
        var items: [[GroupItem]]
        if userMode == .LoggedUser {
            items = [[reminderItem, reminderDateItem],
                     [followingStreamSourceItem, newTodayStreamSourceItem,
                      popularTodayStreamSourceItem, debutsStreamSourceItem],
                     [acknowledgementItem]]
        } else {
            items = [[createAccountItem],
                     [reminderItem, reminderDateItem],
                     [newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem],
                     [acknowledgementItem]]
        }

        // MARK: Super init

        super.init(items: items as [[GroupItem]])

        configureItemsActions()

        // MARK: add observer
        NSNotificationCenter.defaultCenter().addObserver(self,
                selector: #selector(didProvideNotificationSettings),
        name: NotificationKey.UserNotificationSettingsRegistered.rawValue, object: nil)
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

    func configureItemsActions() {
        createAccountItem.onSelect = {
            [weak self] in
            self?.settingsViewController?.authenticateUser()
        }

        acknowledgementItem.onSelect = {
            [weak self] in
            self?.settingsViewController?.presentAcknowledgements()
        }

        // MARK: onValueChanged blocks

        reminderItem.valueChanged = {
            newValue in
            Settings.Reminder.Enabled = newValue
            if newValue == true {
                self.registerUserNotificationSettings()

                if Settings.Reminder.LocalNotificationSettingsProvided == true {
                    self.registerLocalNotification()
                }
            } else {
                self.unregisterLocalNotification()
            }
        }

        reminderDateItem.onValueChanged = {
            date -> Void in
            if self.reminderItem.enabled {
                self.registerLocalNotification()
            }
            Settings.Reminder.Date = date
        }

        followingStreamSourceItem.valueChanged = {
            newValue in
            Settings.StreamSource.Following = newValue
        }

        newTodayStreamSourceItem.valueChanged = {
            newValue in
            Settings.StreamSource.NewToday = newValue
        }

        popularTodayStreamSourceItem.valueChanged = {
            newValue in
            Settings.StreamSource.PopularToday = newValue
        }

        debutsStreamSourceItem.valueChanged = {
            newValue in
            Settings.StreamSource.Debuts = newValue
        }
    }

    func registerUserNotificationSettings() {
        UIApplication.sharedApplication().registerUserNotificationSettings(
        UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
    }

    func registerLocalNotification() {

        let localNotification = LocalNotificationRegistrator.registerNotification(
        forUserID: loggedInUser?.identifier ?? "userID", time: reminderDateItem.date)

        if localNotification == nil {

            alertDelegate?.displayAlert(preparePermissionsAlert())

            reminderItem.enabled = false
            Settings.Reminder.Enabled = false
            delegate?.didChangeItemsAtIndexPaths(indexPathsForItems([reminderItem])!)
        }
    }

    func unregisterLocalNotification() {
        LocalNotificationRegistrator.unregisterNotification(forUserID: loggedInUser?.identifier ?? "userID")
    }

    // MARK: Prepare alert

    func preparePermissionsAlert() -> AOAlertController {
        let message = NSLocalizedString("SettingsViewModel.AccessToNotifications",
                                        comment: "Body of alert, asking user to grant notifications permission.")
        let alert = AOAlertController(title: nil, message: message, style: .Alert)

        let settingsActionTitle = NSLocalizedString("SettingsViewModel.Settings",
                                                    comment: "Redirect user to Settings app")
        let settingsAction = AOAlertAction(title: settingsActionTitle, style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }

        let cancelActionTitle = NSLocalizedString("SettingsViewModel.Dismiss",
                                                  comment: "Notifications alert, dismiss button.")
        let cancelAction = AOAlertAction(title: cancelActionTitle, style: .Default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        return alert
    }
}
