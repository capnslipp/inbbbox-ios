//
//  SettingsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

protocol ModelUpdatable: class {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

protocol AlertDisplayable: class {
    func displayAlert(alert: UIAlertController)
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
    private let createAccountItem: LabelItem
    private let reminderItem: SwitchItem
    private let reminderDateItem: DateItem
    private let followingStreamSourceItem: SwitchItem
    private let newTodayStreamSourceItem: SwitchItem
    private let popularTodayStreamSourceItem: SwitchItem
    private let debutsStreamSourceItem: SwitchItem

    var loggedInUser: User? {
        return UserStorage.currentUser
    }

    init(delegate: ModelUpdatable) {

        // MARK: Parameters

        self.delegate = delegate
        self.alertDelegate = delegate as? AlertDisplayable
        self.userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser

        let createAccountTitle = NSLocalizedString("SettingsViewModel.CreateAccount", comment: "Button text allowing user to create new account.")

        let reminderTitle = NSLocalizedString("SettingsViewModel.EnableDailyReminders", comment: "User settings, enable daily reminders")
        let reminderDateTitle = NSLocalizedString("SettingsViewModel.SendDailyReminders", comment: "User settings, send daily reminders")

        let followingStreamSourceTitle = NSLocalizedString("SettingsViewModel.Following", comment: "User settings, enable following")
        let newTodayStreamSourceTitle = NSLocalizedString("SettingsViewModel.NewToday", comment: "User settings, enable new today.")
        let popularTodayStreamSourceTitle = NSLocalizedString("SettingsViewModel.Popular", comment: "User settings, enable popular today.")
        let debutsStreamSourceTitle = NSLocalizedString("SettingsViewModel.Debuts", comment: "User settings, show debuts.")

        // MARK: Create items

        createAccountItem = LabelItem(title: createAccountTitle)

        reminderItem = SwitchItem(title: reminderTitle, on: Settings.Reminder.Enabled)
        reminderDateItem = DateItem(title: reminderDateTitle, date: Settings.Reminder.Date)

        followingStreamSourceItem = SwitchItem(title: followingStreamSourceTitle, on: Settings.StreamSource.Following)
        newTodayStreamSourceItem = SwitchItem(title: newTodayStreamSourceTitle, on: Settings.StreamSource.NewToday)
        popularTodayStreamSourceItem = SwitchItem(title: popularTodayStreamSourceTitle, on: Settings.StreamSource.PopularToday)
        debutsStreamSourceItem = SwitchItem(title: debutsStreamSourceTitle, on: Settings.StreamSource.Debuts)
        let acknowledgementItem = LabelItem(title: NSLocalizedString("SettingsViewModel.AcknowledgementsButton", comment: "Acknowledgements button"))
        var items: [[GroupItem]]
        if userMode == .LoggedUser {
            items = [[reminderItem, reminderDateItem],
                [followingStreamSourceItem, newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem],
                [acknowledgementItem]]
        } else {
            items = [[createAccountItem],
                [reminderItem, reminderDateItem],
                [newTodayStreamSourceItem, popularTodayStreamSourceItem, debutsStreamSourceItem],
                [acknowledgementItem]]
        }

        // MARK: Super init

        super.init(items: items as [[GroupItem]])

        createAccountItem.onSelect = { [weak self] in
            self?.settingsViewController?.authenticateUser()
        }

        acknowledgementItem.onSelect = { [weak self] in
            self?.settingsViewController?.presentAcknowledgements()
        }

        // MARK: onValueChanged blocks

        reminderItem.onValueChanged = { on in
            Settings.Reminder.Enabled = on
            if on {
                self.registerUserNotificationSettings()

                if Settings.Reminder.LocalNotificationSettingsProvided == true {
                    self.registerLocalNotification()
                }
            } else {
                self.unregisterLocalNotification()
            }
        }

        reminderDateItem.onValueChanged = { date -> Void in
            if self.reminderItem.on {
                self.registerLocalNotification()
            }
            Settings.Reminder.Date = date
        }

        followingStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.Following = on
        }

        newTodayStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.NewToday = on
        }

        popularTodayStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.PopularToday = on
        }

        debutsStreamSourceItem.onValueChanged = { on in
            Settings.StreamSource.Debuts = on
        }

        // MARK: add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didProvideNotificationSettings), name: NotificationKey.UserNotificationSettingsRegistered.rawValue, object: nil)
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

    func registerUserNotificationSettings() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
    }

    func registerLocalNotification() {

        let localNotification = LocalNotificationRegistrator.registerNotification(forUserID: loggedInUser?.identifier ?? "userID", time: reminderDateItem.date)

        if localNotification == nil {

            alertDelegate?.displayAlert(preparePermissionsAlert())

            reminderItem.on = false
            Settings.Reminder.Enabled = false
            delegate?.didChangeItemsAtIndexPaths(indexPathsForItems([reminderItem])!)
        }
    }

    func unregisterLocalNotification() {
        LocalNotificationRegistrator.unregisterNotification(forUserID: loggedInUser?.identifier ?? "userID")
    }

    // MARK: Prepare alert

    func preparePermissionsAlert() -> UIAlertController {

        let alert = UIAlertController(title: NSLocalizedString("SettingsViewModel.Permissions", comment: "Title of alert, asking user to grant notifications permission"), message: NSLocalizedString("SettingsViewModel.AccessToNotifications", comment: "Body of alert, asking user to grant notifications permission."), preferredStyle: .Alert)

        let settingsAction = UIAlertAction(title: NSLocalizedString("SettingsViewModel.Settings", comment: "Redirect user to Settings app"), style: .Default) {
            _ in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("SettingsViewModel.Dismiss", comment: "Notifications alert, dismiss button."), style: .Default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        return alert
    }
}
