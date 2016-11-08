//
//  DayMode.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct DayMode: ColorModeType {

    var tabBarTint: UIColor {
        return .whiteColor()
    }
    
    var tabBarNormalItemTextColor: UIColor {
        return .tabBarGrayColor()
    }
    
    var tabBarSelectedItemTextColor: UIColor {
        return .pinkColor()
    }
    
    var tabBarCenterButtonBackground: UIColor {
        return .whiteColor()
    }
    
    var tabBarCenterButtonShadowOffset: CGSize {
        return CGSize(width: 0, height: 2)
    }
    
    var tabBarCenterButtonShadowColor: UIColor {
        return UIColor(white: 0, alpha: 0.1)
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
    
    var tableViewCellTextColor: UIColor {
        return .blackColor()
    }
    
    // MARK: SwichCell
    var switchCellTintColor: UIColor {
        return .RGBA(143, 142, 148, 1)
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

    var shotDetailsHeaderViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotDetailsOperationViewBackground: UIColor {
        return .RGBA(246, 248, 248, 1)
    }

    var shotDetailsDescriptionCollectionViewCellBackground: UIColor {
        return .whiteColor()
    }

    var shotDetailsCommentCollectionViewCellBackground: UIColor {
        return .whiteColor()
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
    
    // MARK: Settings
    
    var settingsUsernameTextColor: UIColor {
        return .textDarkColor()
    }
    
    var settingsSelectedCellBackgound: UIColor {
        return .RGBA(217, 217, 217, 1)
    }
    
    // MARK: DatePicker
    var datePickerBackgroundColor: UIColor {
        return .whiteColor()
    }
    
    var datePickerTextColor: UIColor {
        return .blackColor()
    }
    
    // MARK: DatePickerView
    var datePickerViewBackgroundColor: UIColor {
        return .backgroundGrayColor()
    }
    
    var datePickerViewSeparatorColor: UIColor {
        return .RGBA(224, 224, 224, 1)
    }
    
    // MARK: Logo
    
    var logoImageName: String {
        return "logo-type-home"
    }
}
