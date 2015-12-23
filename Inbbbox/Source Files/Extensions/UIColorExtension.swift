//
//  UIColorExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func RGBA(red255 red: CGFloat, green255 green: CGFloat, blue255 blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    class func pinkColor() -> UIColor {
        return pinkColor(alpha: 1)
    }
    
    class func pinkColor(alpha alpha: CGFloat) -> UIColor {
        return RGBA(red255: 240, green255: 55, blue255: 126, alpha: alpha)
    }
    
    class func backgroundGrayColor() -> UIColor {
        return RGBA(red255: 246, green255: 248, blue255: 248, alpha: 1)
    }
    
    class func textDarkColor() -> UIColor {
        return RGBA(red255: 51, green255: 51, blue255: 51, alpha: 1)
    }
    
    class func textLightColor() -> UIColor {
        return RGBA(red255: 109, green255: 109, blue255: 114, alpha: 1)
    }
}
