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

    // MARK: ShotDetails
    var shotDetailsHeaderViewBackground: UIColor { get }
    var shotDetailsOperationViewBackground: UIColor { get }
    var shotDetailsDescriptionCollectionViewCellBackground: UIColor { get }
    var shotDetailsCommentCollectionViewCellBackground: UIColor { get }

    /// ProfileHeaderView.
    var profileHeaderViewBackground: UIColor { get }

    // MARK: TwoLayoutCollectionViewController
    var twoLayoutsCollectionViewBackground: UIColor { get }
}
