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

    var navigationBarTint: UIColor {
        return .blackColor()
    }

    var shotsCollectionBackground: UIColor {
        return .blackColor()
    }

    var tableViewBackground: UIColor {
        return .blackColor()
    }

    var tableViewSeparator: UIColor {
        return .blackColor()
    }

    var tableViewCellBackground: UIColor {
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
    
    var settingsCellTextColor: UIColor {
        return .whiteColor()
    }
}
