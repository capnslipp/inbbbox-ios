//
//  ColorModeType.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ColorModeType {
    
    // MARK: UIWindow
    
    var windowBackgroundColor: UIColor { get }

    // MARK: UITabBar
    var tabBarTint: UIColor { get }
    var tabBarNormalItemTextColor: UIColor { get }
    var tabBarSelectedItemTextColor: UIColor { get }
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

    // MARK: UITableView
    var tableViewBackground: UIColor { get }
    var tableViewSeparator: UIColor { get }

    // MARK: UITableViewCell
    var tableViewCellBackground: UIColor { get }

    // MARK: ShotBuckets
    var shotBucketsAddCollectionViewCellBackground: UIColor { get }
    var shotBucketsHeaderViewBackground: UIColor { get }
    var shotBucketsFooterViewBackground: UIColor { get }
    var shotBucketsSeparatorCollectionViewCellBackground: UIColor { get }
    var shotBucketsActionButtonColor: UIColor { get }
    var shotBucketsActionTextColor: UIColor { get }

    // MARK: ShotDetails
    var shotDetailsHeaderViewBackground: UIColor { get }
    var shotDetailsOperationViewBackground: UIColor { get }
    var shotDetailsDescriptionCollectionViewCellBackground: UIColor { get }
    var shotDetailsDescriptionSeparatorColor: UIColor { get }
    var shotDetailsDummySeparatorColor: UIColor { get }
    var shotDetailsCommentCollectionViewCellBackground: UIColor { get }
    var shotDetailsCommentSeparatorColor: UIColor { get }
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
    var shotDetailsFooterBackgroundColor: UIColor { get }
    var shotDetailsFooterBackgroundGrayedColor: UIColor { get }
    
    // MARK: Settings
    var settingsUsernameTextColor: UIColor { get }
    var settingsCellTextColor: UIColor { get }
    var settingsSwitchOnColor: UIColor { get }
    var settingsSwitchOffColor: UIColor { get }

    /// ProfileHeaderView.
    var profileHeaderViewBackground: UIColor { get }

    // MARK: TwoLayoutCollectionViewController
    var twoLayoutsCollectionViewBackground: UIColor { get }
    
    var visualEffectBlurType: UIBlurEffectStyle { get }
    
    // MARK: Logo
    var logoImageName: String { get }
    
    func isEqualTo(other: ColorModeType) -> Bool
}

func ==(lhs: ColorModeType, rhs: ColorModeType) -> Bool {
  return lhs.isEqualTo(rhs)
}
