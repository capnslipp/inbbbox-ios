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
    var tabBarCenterButtonBackground: UIColor { get }
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
    
    // MARK: CommentComposer
    var commentComposerViewBackground: UIColor { get }
    
    // MARK: Common
    var shadowColor: UIColor { get }
    var cellSeparator: UIColor { get }
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle { get }
    var visualEffectBlurType: UIBlurEffectStyle { get }
    
    func isEqualTo(other: ColorModeType) -> Bool
}

func ==(lhs: ColorModeType, rhs: ColorModeType) -> Bool {
    return lhs.isEqualTo(rhs)
}
