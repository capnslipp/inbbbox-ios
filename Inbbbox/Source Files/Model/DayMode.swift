//
//  DayMode.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct DayMode: ColorModeType {
    
    var windowBackgroundColor: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var tabBarTint: UIColor {
        return .whiteColor()
    }
    
    var tabBarNormalItemTextColor: UIColor {
        return .tabBarGrayColor()
    }
    
    var tabBarSelectedItemTextColor: UIColor {
        return .pinkColor()
    }
    
    var tabBarLikesNormalImageName: String {
        return "ic-likes"
    }
    
    var tabBarLikesSelectedImageName: String {
        return "ic-likes-active"
    }
    
    var tabBarBucketsNormalImageName: String {
        return "ic-buckets"
    }
    
    var tabBarBucketsSelectedImageName: String {
        return "ic-buckets-active"
    }
    
    var tabBarCenterButtonNormalImageName: String {
        return "ic-ball-inactive"
    }
    
    var tabBarCenterButtonSelectedImageName: String {
        return "ic-ball-active"
    }
    
    var tabBarFollowingNormalImageName: String {
        return "ic-following"
    }
    
    var tabBarFollowingSelectedImageName: String {
        return "ic-following-active"
    }
    
    var tabBarSettingsNormalImageName: String {
        return "ic-settings"
    }
    
    var tabBarSettingsSelectedImageName: String { 
        return "ic-settings-active"
    }

    var navigationBarTint: UIColor {
        return .pinkColor()
    }

    var shotsCollectionBackground: UIColor {
        return .backgroundGrayColor()
    }

    var tableViewBackground: UIColor {
        return .backgroundGrayColor()
    }

    var tableViewSeparator: UIColor {
        return .RGBA(200, 199, 204, 1)
    }

    var tableViewCellBackground: UIColor {
        return .whiteColor()
    }

    var shotBucketsAddCollectionViewCellBackground: UIColor {
        return .whiteColor()
    }

    var shotBucketsHeaderViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotBucketsFooterViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotBucketsSeparatorCollectionViewCellBackground: UIColor {
        return UIColor.RGBA(246, 248, 248, 1)
    }
    
    var shotBucketsActionButtonColor: UIColor {
        return .whiteColor()
    }
    
    var shotBucketsActionTextColor: UIColor {
        return .pinkColor()
    }

    var shotDetailsHeaderViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotDetailsOperationViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotDetailsDescriptionCollectionViewCellBackground: UIColor {
        return .whiteColor()
    }

    var shotDetailsDescriptionSeparatorColor: UIColor {
        return .separatorGrayColor()
    }
    
    var shotDetailsDummySeparatorColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsCommentCollectionViewCellBackground: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsCommentSeparatorColor: UIColor {
        return .clearColor()
    }

    var profileHeaderViewBackground: UIColor {
        return .pinkColor()
    }

    var twoLayoutsCollectionViewBackground: UIColor {
        return .backgroundGrayColor()
    }
    
    // MARK: Shot Detail
    
    var shotDetailsHeaderViewTitleLabelTextColor: UIColor {
        return .blackColor()
    }
    
    var shotDetailsHeaderViewOverLapingTitleLabelTextColor: UIColor {
        return .pinkColor()
    }
    
    var shotDetailsHeaderViewAuthorNotLinkColor: UIColor {
        return .grayColor()
    }
    
    var shotDetailsHeaderViewAuthorLinkColor: UIColor {
        return .pinkColor()
    }
    
    var shotDetailsCommentContentTextColor: UIColor {
        return .grayColor()
    }
    
    var shotDetailsDescriptionViewColorTextColor: UIColor {
        return .grayColor()
    }
    
    var shotDetailsCommentAuthorTextColor: UIColor {
        return .textDarkColor()
    }
    
    var shotDetailsCommentLikesCountTextColor: UIColor {
        return .followeeTextGrayColor()
    }
    
    var shotDetailsCommentDateTextColor: UIColor {
        return .followeeTextGrayColor()
    }
    
    var shotDetailsCommentLinkTextColor: UIColor {
        return .pinkColor()
    }
    
    var shotDetailsCommentEditLabelTextColor: UIColor {
        return .followeeTextGrayColor()
    }
    
    var shotDetailsBucketTextColor: UIColor {
        return .RGBA(87, 98, 103, 1)
    }
    
    var shotDetailsFooterBackgroundColor: UIColor {
        return .whiteColor()
    }
    
    var shotDetailsFooterBackgroundGrayedColor: UIColor {
        return .RGBA(246, 248, 248, 1)
    }
    
    // MARK: Settings
    
    var settingsUsernameTextColor: UIColor {
        return .textDarkColor()
    }
    
    var settingsCellTextColor: UIColor {
        return .blackColor()
    }
    
    var settingsSwitchOnColor: UIColor {
        return .pinkColor()
    }
    
    var settingsSwitchOffColor: UIColor {
        return .RGBA(143, 142, 148, 1)
    }
    
    var visualEffectBlurType: UIBlurEffectStyle {
        return .Light
    }
    
    // MARK: Logo
    
    var logoImageName: String {
        return "logo-type-home"
    }
    
    func isEqualTo(other: ColorModeType) -> Bool {
        if let o = other as? DayMode { return self == o }
        return false
    }
}
