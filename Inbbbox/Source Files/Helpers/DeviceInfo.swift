//
//  DeviceInfo.swift
//  Inbbbox
//
//  Created by Tomasz W on 30/09/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DeviceInfo {

    class func shouldDowngrade() -> Bool {
        if UIDevice.currentDevice().deviceType == DeviceType.iPadMini
            || UIDevice.currentDevice().deviceType == DeviceType.iPhone4S {
            return true
        }
        return false
    }
}
