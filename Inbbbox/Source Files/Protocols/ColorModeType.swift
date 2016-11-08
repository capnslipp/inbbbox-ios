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

    // MARK: UITableView
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

    // MARK: ShotDetails
    var shotDetailsHeaderViewBackground: UIColor { get }
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
}

func ==(lhs: ColorModeType, rhs: ColorModeType) -> Bool {
    return lhs.tabBarTint == rhs.tabBarTint &&
    lhs.navigationBarTint == rhs.navigationBarTint &&
    lhs.shotsCollectionBackground == rhs.shotsCollectionBackground &&
    lhs.tableViewBackground == rhs.tableViewBackground &&
    lhs.tableViewSeparator == rhs.tableViewSeparator &&
    lhs.tableViewCellBackground == rhs.tableViewCellBackground &&
    lhs.shotBucketsAddCollectionViewCellBackground == rhs.shotBucketsAddCollectionViewCellBackground &&
    lhs.shotBucketsHeaderViewBackground == rhs.shotBucketsHeaderViewBackground &&
    lhs.shotBucketsFooterViewBackground == rhs.shotBucketsFooterViewBackground &&
    lhs.shotBucketsSeparatorCollectionViewCellBackground == rhs.shotBucketsSeparatorCollectionViewCellBackground &&
    lhs.shotDetailsHeaderViewBackground == rhs.shotDetailsHeaderViewBackground &&
    lhs.shotDetailsOperationViewBackground == rhs.shotDetailsOperationViewBackground &&
    lhs.shotDetailsDescriptionCollectionViewCellBackground == rhs.shotDetailsDescriptionCollectionViewCellBackground &&
    lhs.shotDetailsCommentCollectionViewCellBackground == rhs.shotDetailsCommentCollectionViewCellBackground &&
    lhs.profileHeaderViewBackground == rhs.profileHeaderViewBackground &&
    lhs.twoLayoutsCollectionViewBackground == rhs.twoLayoutsCollectionViewBackground
}
