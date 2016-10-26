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

    var tableViewCellBackground: UIColor {
        return .whiteColor()
    }

    var shotBucketsAddCollectionViewCellBackground: UIColor {
        return .whiteColor()
    }
}
