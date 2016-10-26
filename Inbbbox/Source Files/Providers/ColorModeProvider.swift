//
//  ColorModeProvider.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum ColorMode: String {
    case DayMode
    case NightMode
}

final class ColorModeProvider {

    // MARK: Internal

    class func setup() {
        let currentMode = Settings.Customization.CurrentColorMode
        select(currentMode)
    }

    class func change(to mode: ColorMode) {
        Settings.Customization.CurrentColorMode = mode
        ColorModeProvider.setup()
    }

    class func current() -> ColorModeType {
        let currentMode = Settings.Customization.CurrentColorMode
        switch currentMode {
        case .DayMode: return DayMode()
        case .NightMode: return NightMode()
        }
    }

    // MARK: Private

    private class func select(mode: ColorMode) {
        switch mode {
        case .DayMode: ColorModeProvider.adaptInterface(to: DayMode())
        case .NightMode: ColorModeProvider.adaptInterface(to: NightMode())
        }
    }

    private class func adaptInterface(to color: ColorModeType) {
        UITabBar.appearance().barTintColor = color.tabBarTint
        UINavigationBar.appearance().barTintColor = color.navigationBarTint
        UITableView.appearance().backgroundColor = color.tableViewBackground
        UITableViewCell.appearance().backgroundColor = color.tableViewCellBackground

        ShotsCollectionBackgroundView.appearance().backgroundColor = color.shotsCollectionBackground
        ShotBucketsAddCollectionViewCell.appearance().backgroundColor = color.shotBucketsAddCollectionViewCellBackground

        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false

        ColorModeProvider.resetViews()
    }

    private class func resetViews() {
        let windows = UIApplication.sharedApplication().windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
            }
        }
    }
}
