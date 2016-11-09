//
//  ColorModeType.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ColorModeType {

    // MARK: UITabBar
    var tabBarTint: UIColor { get }
    var tabBarNormalItemTextColor: UIColor { get }
    var tabBarSelectedItemTextColor: UIColor { get }
    var tabBarCenterButtonBackground: UIColor { get }
    var tabBarCenterButtonShadowColor: UIColor { get }
    var tabBarCenterButtonShadowOffset: CGSize { get }
    var tabBarLikesNormalImageName: String { get }
    var tabBarLikesSelectedImageName: String { get }
    var tabBarBucketsNormalImageName: String { get }
    var tabBarBucketsSelectedImageName: String { get }
    var tabBarCenterButtonNormalImageName: String { get }
    var tabBarCenterButtonSelectedImageName: String { get }
    var tabBarFollowingNormalImageName: String { get }
    var tabBarFollowingSelectedImageName: String { get }
    var tabBarSettingsNormalImageName: String { get }
    var tabBarSettingsSelectedImageName: String { get }

    // MARK: UINavigationBar
    var navigationBarTint: UIColor { get }

    // MARK: ShotsCollection
    var shotsCollectionBackground: UIColor { get }
    
    // MARK: ShotCell
    var shotViewCellBackground: UIColor { get }

    // MARK: UITableView
    var tableViewBlurColor: UIColor { get }
    var tableViewBackground: UIColor { get }
    var tableViewSeparator: UIColor { get }

    // MARK: UITableViewCell
    var tableViewCellBackground: UIColor { get }
    var tableViewCellTextColor: UIColor { get }
    
    // MARK: SwichCell
    var switchCellTintColor: UIColor { get }

    // MARK: ShotBuckets
    var shotBucketsAddCollectionViewCellBackground: UIColor { get }
    var shotBucketsHeaderViewBackground: UIColor { get }
    var shotBucketsFooterViewBackground: UIColor { get }
    var shotBucketsSeparatorCollectionViewCellBackground: UIColor { get }
    var bucketsCollectionViewBackground: UIColor { get }
    var emptyBucketImageName: String { get }

    // MARK: ShotDetails
    var shotDetailsHeaderViewBackground: UIColor { get }
    var shotDummySpaceBackground: UIColor { get }
    var shotDetailsOperationViewBackground: UIColor { get }
    var shotDetailsDescriptionCollectionViewCellBackground: UIColor { get }
    var shotDetailsCommentCollectionViewCellBackground: UIColor { get }
    var shotDetailsHeaderViewTitleLabelTextColor: UIColor { get }
    var shotDetailsHeaderViewOverLapingTitleLabelTextColor: UIColor { get }
    var shotDetailsHeaderViewAuthorNotLinkColor: UIColor { get }
    var shotDetailsHeaderViewAuthorLinkColor: UIColor { get }
    var shotDetailsDescriptionViewColorTextColor: UIColor { get }
    var shotDetailsCommentAuthorTextColor: UIColor { get }
    var shotDetailsCommentContentTextColor: UIColor { get }
    var shotDetailsCommentLikesCountTextColor: UIColor { get }
    var shotDetailsCommentDateTextColor: UIColor { get }
    var shotDetailsCommentLinkTextColor: UIColor { get }
    var shotDetailsCommentEditLabelTextColor: UIColor { get }
    var shotDetailsBucketTextColor: UIColor { get }
    var shotDetailsSeparatorColor: UIColor { get }
    var shotDetailsEditViewBackground: UIColor { get }
    var shotBucketsActionCellBackground: UIColor { get }
    
    // MARK: Settings
    var settingsUsernameTextColor: UIColor { get }
    var settingsSelectedCellBackgound: UIColor { get }
    
    // MARK: DatePicker
    var datePickerBackgroundColor: UIColor { get }
    var datePickerTextColor: UIColor { get }
    
    // MARK: DatePickerView
    var datePickerViewBackgroundColor: UIColor { get }
    var datePickerViewSeparatorColor: UIColor { get }

    /// ProfileHeaderView.
    var profileHeaderViewBackground: UIColor { get }

    // MARK: TwoLayoutCollectionViewController
    var twoLayoutsCollectionViewBackground: UIColor { get }
    
    // MARK: Logo
    var logoImageName: String { get }
    
    // MARK: StatusBar
    var preferredStatusBarStyle: UIStatusBarStyle { get }
}

func ==(lhs: ColorModeType, rhs: ColorModeType) -> Bool {
    return  lhs.tabBarTint == rhs.tabBarTint &&
        lhs.tabBarNormalItemTextColor == rhs.tabBarNormalItemTextColor &&
        lhs.tabBarSelectedItemTextColor == rhs.tabBarSelectedItemTextColor &&
        lhs.tabBarCenterButtonBackground == rhs.tabBarCenterButtonBackground &&
        lhs.tabBarCenterButtonShadowColor == rhs.tabBarCenterButtonShadowColor &&
        lhs.tabBarCenterButtonShadowOffset == rhs.tabBarCenterButtonShadowOffset &&
        lhs.tabBarLikesNormalImageName == rhs.tabBarLikesNormalImageName &&
        lhs.tabBarLikesSelectedImageName == rhs.tabBarLikesSelectedImageName &&
        lhs.tabBarBucketsNormalImageName == rhs.tabBarBucketsNormalImageName &&
        lhs.tabBarBucketsSelectedImageName == rhs.tabBarBucketsSelectedImageName &&
        lhs.tabBarCenterButtonNormalImageName == rhs.tabBarCenterButtonNormalImageName &&
        lhs.tabBarCenterButtonSelectedImageName == rhs.tabBarCenterButtonSelectedImageName &&
        lhs.tabBarFollowingNormalImageName == rhs.tabBarFollowingNormalImageName &&
        lhs.tabBarFollowingSelectedImageName == rhs.tabBarFollowingSelectedImageName &&
        lhs.tabBarSettingsNormalImageName == rhs.tabBarSettingsNormalImageName &&
        lhs.tabBarSettingsSelectedImageName == rhs.tabBarSettingsSelectedImageName &&
        lhs.navigationBarTint == rhs.navigationBarTint &&
        lhs.shotsCollectionBackground == rhs.shotsCollectionBackground &&
        lhs.shotViewCellBackground == rhs.shotViewCellBackground &&
        lhs.tableViewBackground == rhs.tableViewBackground &&
        lhs.tableViewSeparator == rhs.tableViewSeparator &&
        lhs.tableViewCellBackground == rhs.tableViewCellBackground &&
        lhs.tableViewCellTextColor == rhs.tableViewCellTextColor &&
        lhs.switchCellTintColor == rhs.switchCellTintColor &&
        lhs.shotBucketsAddCollectionViewCellBackground == rhs.shotBucketsAddCollectionViewCellBackground &&
        lhs.shotBucketsHeaderViewBackground == rhs.shotBucketsHeaderViewBackground &&
        lhs.shotBucketsFooterViewBackground == rhs.shotBucketsFooterViewBackground &&
        lhs.shotBucketsSeparatorCollectionViewCellBackground == rhs.shotBucketsSeparatorCollectionViewCellBackground &&
        lhs.bucketsCollectionViewBackground == rhs.bucketsCollectionViewBackground &&
        lhs.shotDetailsHeaderViewBackground == rhs.shotDetailsHeaderViewBackground &&
        lhs.shotDetailsOperationViewBackground == rhs.shotDetailsOperationViewBackground &&
        lhs.shotDetailsDescriptionCollectionViewCellBackground == rhs.shotDetailsDescriptionCollectionViewCellBackground &&
        lhs.shotDetailsCommentCollectionViewCellBackground == rhs.shotDetailsCommentCollectionViewCellBackground &&
        lhs.shotDetailsHeaderViewTitleLabelTextColor == rhs.shotDetailsHeaderViewTitleLabelTextColor &&
        lhs.shotDetailsHeaderViewOverLapingTitleLabelTextColor == rhs.shotDetailsHeaderViewOverLapingTitleLabelTextColor &&
        lhs.shotDetailsHeaderViewAuthorNotLinkColor == rhs.shotDetailsHeaderViewAuthorNotLinkColor &&
        lhs.shotDetailsHeaderViewAuthorLinkColor == rhs.shotDetailsHeaderViewAuthorLinkColor &&
        lhs.shotDetailsDescriptionViewColorTextColor == rhs.shotDetailsDescriptionViewColorTextColor &&
        lhs.shotDetailsCommentAuthorTextColor == rhs.shotDetailsCommentAuthorTextColor &&
        lhs.shotDetailsCommentContentTextColor == rhs.shotDetailsCommentContentTextColor &&
        lhs.shotDetailsCommentLikesCountTextColor == rhs.shotDetailsCommentLikesCountTextColor &&
        lhs.shotDetailsCommentDateTextColor == rhs.shotDetailsCommentDateTextColor &&
        lhs.shotDetailsCommentLinkTextColor == rhs.shotDetailsCommentLinkTextColor &&
        lhs.shotDetailsCommentEditLabelTextColor == rhs.shotDetailsCommentEditLabelTextColor &&
        lhs.shotDetailsBucketTextColor == rhs.shotDetailsBucketTextColor &&
        lhs.settingsUsernameTextColor == rhs.settingsUsernameTextColor &&
        lhs.settingsSelectedCellBackgound == rhs.settingsSelectedCellBackgound &&
        lhs.datePickerBackgroundColor == rhs.datePickerBackgroundColor &&
        lhs.datePickerTextColor == rhs.datePickerTextColor &&
        lhs.datePickerViewBackgroundColor == rhs.datePickerViewBackgroundColor &&
        lhs.datePickerViewSeparatorColor == rhs.datePickerViewSeparatorColor &&
        lhs.profileHeaderViewBackground == rhs.profileHeaderViewBackground &&
        lhs.twoLayoutsCollectionViewBackground == rhs.twoLayoutsCollectionViewBackground &&
        lhs.logoImageName == rhs.logoImageName &&
        lhs.preferredStatusBarStyle == rhs.preferredStatusBarStyle
}
