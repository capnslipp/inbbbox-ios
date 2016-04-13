//
//  AppDelegate.swift
//  Inbbbox
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import CoreData
import Haneke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {

        AnalyticsManager.setupAnalytics()
        CrashManager.setup()
        let rootViewController = UserStorage.isUserSignedIn ? CenterButtonTabBarController() : LoginViewController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        window!.tintColor = UIColor.whiteColor()
        window!.backgroundColor = UIColor.backgroundGrayColor()
        UINavigationBar.appearance().barTintColor = UIColor.pinkColor()
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false

        configureInitialSettings()
        CacheManager.setupCache()
        return true
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?,
                     forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        // NGRTodo: start loading images from Dribbble,
        // but first, check if notificationID == currentUserID
    }

    func application(application: UIApplication,
                     didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        let notificationName = NotificationKey.UserNotificationSettingsRegistered.rawValue
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL? = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                inDomains: .UserDomainMask)
        return urls.last
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("StoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory?.URLByAppendingPathComponent("StoreData.sqlite")

        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil,
                    URL: url, options: nil)
        } catch {
            let userInfo = [
                    NSLocalizedDescriptionKey: "Failed to initialize the application's saved data",
                    NSLocalizedFailureReasonErrorKey: "There was an error creating " +
                            "or loading the application's saved data."
            ]

            let wrappedError = NSError(domain: "co.netguru.inbbbox.coredata", code: 1001, userInfo: userInfo)

            // NGRTemp: Handle wrappedError

            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
}

// MARK: Initial configuration

private extension AppDelegate {

    func configureInitialSettings() {
        if !Settings.StreamSource.IsSet {
            Settings.StreamSource.PopularToday = true
            Settings.StreamSource.IsSet = true
        }
    }
}
