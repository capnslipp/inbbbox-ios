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

    var navigationBarTint: UIColor {
        return .blackColor()
    }

    var shotsCollectionBackground: UIColor {
        return .blackColor()
    }

    var tableViewBackground: UIColor {
        return .blackColor()
    }

    var tableViewCellBackground: UIColor {
        return .blackColor()
    }

    var shotBucketsAddCollectionViewCellBackground: UIColor {
        return .blackColor()
    }
}
