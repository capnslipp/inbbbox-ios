//
//  ColorModeType.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 26.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ColorModeType {
    var tabBarTint: UIColor { get }
    var navigationBarTint: UIColor { get }
    var shotsCollectionBackground: UIColor { get }
    var tableViewBackground: UIColor { get }
    var tableViewCellBackground: UIColor { get }
    var shotBucketsAddCollectionViewCellBackground: UIColor { get }
}
