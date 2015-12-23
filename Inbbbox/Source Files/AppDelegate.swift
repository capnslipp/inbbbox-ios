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
        let initialShotsCollectionViewController = InitialShotsCollectionViewController()
        let shotsContainerViewController = ShotsContainerViewController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [shotsContainerViewController]
        window!.rootViewController = tabBarController 
        window!.makeKeyAndVisible()
        
        return true
    }
}

