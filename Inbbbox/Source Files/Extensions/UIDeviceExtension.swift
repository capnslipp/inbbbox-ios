//
//  UIDeviceExtension.swift
//  Inbbbox
//
//  Created by Tomasz W on 29/09/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceType: String {
    case notAvailable   = "notAvailable"

    case iPhone2G       = "iPhone2G"
    case iPhone3G       = "iPhone3G"
    case iPhone3GS      = "iPhone3GS"
    case iPhone4        = "iPhone4"
    case iPhone4S       = "iPhone4S"
    case iPhone5        = "iPhone5"
    case iPhone5C       = "iPhone5C"
    case iPhone5S       = "iPhone5S"
    case iPhone6Plus    = "iPhone6Plus"
    case iPhone6        = "iPhone6"
    case iPhone6S       = "iPhone6S"
    case iPhone6SPlus   = "iPhone6SPlus"
    case iPhone7        = "iPhone7"
    case iPhone7Plus    = "iPhone7Plus"
    case iPhoneSE       = "iPhoneSE"

    case iPodTouch1G    = "iPodTouch1G"
    case iPodTouch2G    = "iPodTouch2G"
    case iPodTouch3G    = "iPodTouch3G"
    case iPodTouch4G    = "iPodTouch4G"
    case iPodTouch5G    = "iPodTouch5G"

    case iPad           = "iPad"
    case iPad2          = "iPad2"
    case iPad3          = "iPad3"
    case iPad4          = "iPad4"
    case iPadMini       = "iPadMini"
    case iPadMiniRetina = "iPadMiniRetina"
    case iPadMini3      = "iPadMini3"

    case iPadAir        = "iPadAir"
    case iPadAir2       = "iPadAir2"

    case iPadPro        = "iPadPro"

    case simulator      = "simulator"
}


public extension UIDevice {

    var deviceType: DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children {
            if let value = child.value as? Int8 where value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }

        return parseDeviceType(identifier)
    }


    func parseDeviceType(identifier: String) -> DeviceType {
    
        if identifier == "i386" || identifier == "x86_64" {
            return .simulator
        }

        var deviceType: DeviceType?

        switch identifier {
            case "iPhone1,1": deviceType = .iPhone2G
            case "iPhone1,2": deviceType = .iPhone3G
            case "iPhone2,1": deviceType = .iPhone3GS
            case "iPhone3,1", "iPhone3,2", "iPhone3,3": deviceType = .iPhone4
            case "iPhone4,1": deviceType = .iPhone4S
            case "iPhone5,1", "iPhone5,2": deviceType = .iPhone5
            case "iPhone5,3", "iPhone5,4": deviceType = .iPhone5C
            case "iPhone6,1", "iPhone6,2": deviceType = .iPhone5S
            case "iPhone7,1": deviceType = .iPhone6Plus
            case "iPhone7,2": deviceType = .iPhone6
            case "iPhone8,2": deviceType = .iPhone6SPlus
            case "iPhone8,1": deviceType = .iPhone6S
            case "iPhone8,4": deviceType = .iPhoneSE

            case "iPod1,1": deviceType = .iPodTouch1G
            case "iPod2,1": deviceType = .iPodTouch2G
            case "iPod3,1": deviceType = .iPodTouch3G
            case "iPod4,1": deviceType = .iPodTouch4G
            case "iPod5,1": deviceType = .iPodTouch5G

            case "iPad1,1", "iPad1,2": deviceType = .iPad
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": deviceType = .iPad2
            case "iPad2,5", "iPad2,6", "iPad2,7": deviceType = .iPadMini
            case "iPad3,1", "iPad3,2", "iPad3,3": deviceType = .iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6": deviceType = .iPad4
            case "iPad4,1", "iPad4,2", "iPad4,3": deviceType = .iPadAir
            case "iPad4,4", "iPad4,5", "iPad4,6": deviceType = .iPadMiniRetina
            case "iPad4,7", "iPad4,8": deviceType = .iPadMini3
            case "iPad5,3", "iPad5,4": deviceType = .iPadAir2
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": deviceType = .iPadPro

            default: deviceType = .notAvailable
        }
        return deviceType
}

}
