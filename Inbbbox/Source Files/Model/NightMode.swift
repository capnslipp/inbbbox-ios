//
//  NightMode.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct NightMode: ColorModeType {
    
    var windowBackgroundColor: UIColor {
        return .backgroundNightModeGrayColor()
    }

    var tabBarTint: UIColor {
        return .blackColor()
    }
    
    var tabBarNormalItemTextColor: UIColor {
        return .whiteColor()
    }
    
    var tabBarSelectedItemTextColor: UIColor {
        return .pinkColor()
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
        return .backgroundNightModeGrayColor()
    }

    var tableViewBackground: UIColor {
        return .backgroundNightModeGrayColor()
    }

    var tableViewSeparator: UIColor {
        return .blackColor()
    }

    var tableViewCellBackground: UIColor {
        return lightGrayBackgroundColor
    }

    var shotBucketsAddCollectionViewCellBackground: UIColor {
        return lightGrayBackgroundColor
    }

    var shotBucketsHeaderViewBackground: UIColor {
        return .RGBA(43, 48, 51, 1)
    }

    var shotBucketsFooterViewBackground: UIColor {
        return .RGBA(43, 48, 51, 1)
    }

    var shotBucketsSeparatorCollectionViewCellBackground: UIColor {
        return .RGBA(43, 48, 51, 1)
    }
    
    var shotBucketsActionButtonColor: UIColor {
        return .pinkColor()
    }
    
    var shotBucketsActionTextColor: UIColor {
        return .whiteColor()
    }

    var shotDetailsHeaderViewBackground: UIColor {
        return .RGBA(43, 48, 51, 1)
    }

    var shotDetailsOperationViewBackground: UIColor {
        return .RGBA(43, 48, 51, 1)
    }

    var shotDetailsDescriptionCollectionViewCellBackground: UIColor {
        return lightGrayBackgroundColor
    }
    
    var shotDetailsDescriptionSeparatorColor: UIColor {
        return .clearColor()
    }
    
    var shotDetailsDummySeparatorColor: UIColor {
        return lightGrayBackgroundColor
    }

    var shotDetailsCommentCollectionViewCellBackground: UIColor {
        return lightGrayBackgroundColor
    }
    
    var shotDetailsCommentSeparatorColor: UIColor {
        return .blackColor()
    }

    var profileHeaderViewBackground: UIColor {
        return .blackColor()
    }

    var twoLayoutsCollectionViewBackground: UIColor {
        return .backgroundNightModeGrayColor()
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
    
    var shotDetailsFooterBackgroundColor: UIColor {
        return lightGrayBackgroundColor
    }
    
    var shotDetailsFooterBackgroundGrayedColor: UIColor {
        return lightGrayBackgroundColor
    }
    
    // MARK: Settings
    
    var settingsUsernameTextColor: UIColor {
        return .RGBA(236, 237, 239, 1)
    }
    
    var settingsCellTextColor: UIColor {
        return .whiteColor()
    }
    
    var settingsSwitchOnColor: UIColor {
        return .pinkColor()
    }
    
    var settingsSwitchOffColor: UIColor {
        return .blackColor()
    }
    
    var visualEffectBlurType: UIBlurEffectStyle {
        return .Dark
    }
    
    private let lightGrayBackgroundColor: UIColor = .RGBA(87, 98, 103, 1)
    
    // MARK: Logo
    
    var logoImageName: String {
        return "logo-type-home-night"
    }
    
    func isEqualTo(other: ColorModeType) -> Bool {
        if let o = other as? NightMode { return self == o }
        return false
    }
    
}
