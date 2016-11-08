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
        return CGSize(width: 0, height: 0)
    }
    
    var tabBarCenterButtonShadowColor: UIColor {
        return .whiteColor()
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
        return "ic-ball-active"
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
        return .blackColor()
    }

    var tableViewBackground: UIColor {
        return .RGBA(43, 49, 51, 1.00)
    }

    var tableViewSeparator: UIColor {
        return .blackColor()
    }

    var tableViewCellBackground: UIColor {
        return .RGBA(87, 98, 103, 1.00)
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
        return .blackColor()
    }

    var shotBucketsFooterViewBackground: UIColor {
        return .blackColor()
    }

    var shotBucketsSeparatorCollectionViewCellBackground: UIColor {
        return .blackColor()
    }

    var shotDetailsHeaderViewBackground: UIColor {
        return .blackColor()
    }

    var shotDetailsOperationViewBackground: UIColor {
        return .blackColor()
    }

    var shotDetailsDescriptionCollectionViewCellBackground: UIColor {
        return .blackColor()
    }

    var shotDetailsCommentCollectionViewCellBackground: UIColor {
        return .blackColor()
    }

    var profileHeaderViewBackground: UIColor {
        return .blackColor()
    }

    var twoLayoutsCollectionViewBackground: UIColor {
        return .blackColor()
    }
    
    // MARK: Shot Detail
    
    var shotDetailsHeaderViewTitleLabelTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsHeaderViewOverLapingTitleLabelTextColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsHeaderViewAuthorNotLinkColor: UIColor {
        return .grayNightModeColor()
    }
    
    var shotDetailsHeaderViewAuthorLinkColor: UIColor {
        return .pinkColor()
    }

    var shotDetailsDescriptionViewColorTextColor: UIColor {
        return .grayNightModeColor()
    }
    
    var shotDetailsCommentAuthorTextColor: UIColor {
        return .grayNightModeColor()
    }
    
    var shotDetailsCommentContentTextColor: UIColor {
        return .grayColor()
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
    
    // MARK: Settings
    
    var settingsUsernameTextColor: UIColor {
        return .RGBA(236, 237, 239, 1)
    }
    
    var settingsSelectedCellBackgound: UIColor {
        return .RGBA(98, 113, 120, 1)
    }
    
    // MARK: DatePicker
    var datePickerBackgroundColor: UIColor {
        return .RGBA(43, 49, 51, 1.00)
    }
    
    var datePickerTextColor: UIColor {
        return .whiteColor()
    }
    
    // MARK: DatePickerView
    var datePickerViewBackgroundColor: UIColor {
        return .RGBA(43, 49, 51, 1.00)
    }
    
    var datePickerViewSeparatorColor: UIColor {
        return .RGBA(43, 49, 51, 1.00)
    }
    
    // MARK: Logo
    
    var logoImageName: String {
        return "logo-type-home-night"
    }
}
