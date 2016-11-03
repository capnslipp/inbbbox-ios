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

    private class func adaptInterface(to mode: ColorModeType) {
        UITabBar.appearance().barTintColor = mode.tabBarTint
        UINavigationBar.appearance().barTintColor = mode.navigationBarTint
        UITableView.appearance().backgroundColor = mode.tableViewBackground
        UITableView.appearance().separatorColor = mode.tableViewSeparator
        UITableViewCell.appearance().backgroundColor = mode.tableViewCellBackground

        ShotsCollectionBackgroundView.appearance().backgroundColor = mode.shotsCollectionBackground
        ShotBucketsAddCollectionViewCell.appearance().backgroundColor = mode.shotBucketsAddCollectionViewCellBackground
        ShotBucketsSeparatorCollectionViewCell.appearance().backgroundColor = mode.shotBucketsSeparatorCollectionViewCellBackground
        ShotBucketsHeaderView.appearance().backgroundColor = mode.shotBucketsHeaderViewBackground
        ShotBucketsFooterView.appearance().backgroundColor = mode.shotBucketsFooterViewBackground
        ShotDetailsHeaderView.appearance().backgroundColor = mode.shotDetailsHeaderViewBackground
        ShotDetailsOperationView.appearance().backgroundColor = mode.shotDetailsOperationViewBackground
        ShotDetailsDescriptionCollectionViewCell.appearance().backgroundColor = mode.shotDetailsDescriptionCollectionViewCellBackground
        ShotDetailsCommentCollectionViewCell.appearance().backgroundColor = mode.shotDetailsCommentCollectionViewCellBackground
        ProfileHeaderView.appearance().backgroundColor = mode.profileHeaderViewBackground

        UICollectionView.appearanceWhenContainedInInstancesOfClasses([TwoLayoutsCollectionViewController.self]).backgroundColor = mode.twoLayoutsCollectionViewBackground

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