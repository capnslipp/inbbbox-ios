//
//  AppDelegate.swift
//  Inbbbox
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = LoginViewController()
        window!.makeKeyAndVisible()
        window!.tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.pinkColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        // NGRTodo: start loading images from Dribble
    }
}

