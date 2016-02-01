//
//  UIColorExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIColor {

    class func RGBA(red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    class func pinkColor() -> UIColor {
        return pinkColor(alpha: 1)
    }

    class func pinkColor(alpha alpha: CGFloat) -> UIColor {
        return RGBA(240, 55, 126, alpha)
    }

    class func backgroundGrayColor() -> UIColor {
        return UIColor(white: 0.93, alpha: 1.0)
    }

    class func textDarkColor() -> UIColor {
        return RGBA(51, 51, 51, 1)
    }

    class func textLightColor() -> UIColor {
        return RGBA(109, 109, 114, 1)
    }

    class func tabBarGrayColor() -> UIColor {
        return RGBA(41, 41, 41, 1)
    }
    
    class func cellGrayColor() -> UIColor {
        return RGBA(223, 224, 226, 1)
    }

    class func randomColor() -> UIColor {

        let red = Int(arc4random() % 256)
        let green = Int(arc4random() % 256)
        let blue = Int(arc4random() % 256)

        return RGBA(red, green, blue, 1)
    }
}
