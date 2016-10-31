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
}
