//
//  NightMode.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct NightMode: ColorModeType {

    var tabBarTint: UIColor {
        return .blackColor()
    }
    
    var tabBarNormalItemTextColor: UIColor {
        return .whiteColor()
    }
    
    var tabBarSelectedItemTextColor: UIColor {
        return .pinkColor()
    }
    
    var tabBarCenterButtonBackground: UIColor {
        return .blackColor()
    }
    
    var tabBarCenterButtonShadowOffset: CGSize {
        return CGSize(width: 0, height: 2)
    }
    
    var tabBarCenterButtonShadowColor: UIColor {
        return UIColor(white: 1, alpha: 0.15)
    }
    
    var tabBarLikesNormalImageName: String {
        return "ic-likes-night"
    }
    
    var tabBarLikesSelectedImageName: String {
        return "ic-likes-active"
    }
    
    var tabBarBucketsNormalImageName: String {
        return "ic-buckets-night"
    }
    
    var tabBarBucketsSelectedImageName: String {
        return "ic-buckets-active"
    }
    
    var tabBarCenterButtonNormalImageName: String {
        return "ic-ball-inactive-night"
    }
    
    var tabBarCenterButtonSelectedImageName: String {
        return "ic-ball-active-night"
    }
    
    var tabBarFollowingNormalImageName: String {
        return "ic-following-night"
    }
    
    var tabBarFollowingSelectedImageName: String {
        return "ic-following-active"
    }
    
    var tabBarSettingsNormalImageName: String {
        return "ic-settings-night"
    }
    
    var tabBarSettingsSelectedImageName: String { 
        return "ic-settings-active"
    }

    var navigationBarTint: UIColor {
        return .blackColor()
    }

    var shotsCollectionBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    // MARK: ShotCell
    var shotViewCellBackground: UIColor {
        return .RGBA(98, 113, 120, 1)
    }
    
    // MARK: UITableView
    var tableViewBlurColor: UIColor {
        return .RGBA(71, 72, 72, 1)
    }

    var tableViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }

    var tableViewSeparator: UIColor {
        return .blackColor()
    }

    var tableViewCellBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }
    
    var tableViewCellTextColor: UIColor {
        return .whiteColor()
    }
    
    // MARK: SwichCell
    var switchCellTintColor: UIColor {
        return .blackColor()
    }

    var shotBucketsAddCollectionViewCellBackground: UIColor {
        return .blackColor()
    }

    var shotBucketsHeaderViewBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }

    var shotBucketsFooterViewBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }

    var shotBucketsSeparatorCollectionViewCellBackground: UIColor {
        return .blackColor()
    }
    
    var bucketsCollectionViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    var emptyBucketImageName: String {
        return "ic-bucket-emptystate-night"
    }

    var shotDetailsHeaderViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }

    var shotDetailsOperationViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }

    var shotDetailsDescriptionCollectionViewCellBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }

    var shotDetailsCommentCollectionViewCellBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }

    var profileHeaderViewBackground: UIColor {
        return .blackColor()
    }

    var twoLayoutsCollectionViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    // MARK: Shot Detail
    
    var shotDetailsHeaderViewTitleLabelTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDummySpaceBackground: UIColor {
        return .RGBA(87, 98, 103, 1)
    }
    
    var shotDetailsHeaderViewOverLapingTitleLabelTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsHeaderViewAuthorNotLinkColor: UIColor {
        return .RGBA(223, 224, 226, 1)
    }
    
    var shotDetailsHeaderViewAuthorLinkColor: UIColor {
        return .pinkColor()
    }

    var shotDetailsDescriptionViewColorTextColor: UIColor {
        return .RGBA(223, 224, 226, 1)
    }
    
    var shotDetailsCommentAuthorTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsCommentContentTextColor: UIColor {
        return .RGBA(223, 224, 226, 1)
    }
    
    var shotDetailsCommentLikesCountTextColor: UIColor {
        return .followeeTextGrayNightModeColor()
    }
    
    var shotDetailsCommentDateTextColor: UIColor {
        return .followeeTextGrayNightModeColor()
    }
    
    var shotDetailsCommentLinkTextColor: UIColor {
        return .pinkColor()
    }
    
    var shotDetailsCommentEditLabelTextColor: UIColor {
        return .followeeTextGrayNightModeColor()
    }
    
    var shotDetailsBucketTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsSeparatorColor: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    var shotDetailsEditViewBackground: UIColor {
        return .greenColor()
    }
    
    // MARK: Settings
    var settingsUsernameTextColor: UIColor {
        return .RGBA(236, 237, 239, 1)
    }
    
    var settingsSelectedCellBackgound: UIColor {
        return .RGBA(98, 113, 120, 1)
    }
    
    // MARK: DatePicker
    var datePickerBackgroundColor: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    var datePickerTextColor: UIColor {
        return .whiteColor()
    }
    
    // MARK: DatePickerView
    var datePickerViewBackgroundColor: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    var datePickerViewSeparatorColor: UIColor {
        return .RGBA(43, 49, 51, 1)
    }
    
    // MARK: Logo
    var logoImageName: String {
        return "logo-type-home-night"
    }
    
    // MARK: StatusBar
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .LightContent
    }
}
