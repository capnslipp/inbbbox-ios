//
//  UIColorExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

/// Extension for predefined colors in Inbbbox app.
extension UIColor {

    /// Color based on RGB color model and alpha parameter.
    ///
    /// - parameter red:    Integer value of red color.
    /// - parameter green:  Integer value of green color.
    /// - parameter blue:   Integer value of blue color.
    /// - parameter alpha:  Float value of alpha. Needs to be between 0 and 1.
    ///
    /// - returns: Instance of UIColor.
    class func RGBA(red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0,
                     green: CGFloat(green) / 255.0,
                      blue: CGFloat(blue) / 255.0,
                     alpha: alpha)
    }

    /// Returns brand pink color.
    class func pinkColor() -> UIColor {
        return pinkColor(alpha: 1)
    }

    /// Brand pink color with additional parameter alpha.
    ///
    /// - parameter alpha: float value of alpha. Needs to be between 0 and 1.
    ///
    /// - returns: pink color with set level of transparency.
    class func pinkColor(alpha alpha: CGFloat) -> UIColor {
        return RGBA(240, 55, 126, alpha)
    }

    /// Returns brand background gray color.
    class func backgroundGrayColor() -> UIColor {
        return RGBA(246, 248, 248, 1)
    }

    /// Returns brand text dark color.
    class func textDarkColor() -> UIColor {
        return RGBA(51, 51, 51, 1)
    }

    /// Returns brand text light color.
    class func textLightColor() -> UIColor {
        return RGBA(109, 109, 114, 1)
    }

    /// Returns brand text gray color used in followee cell.
    class func followeeTextGrayColor() -> UIColor {
        return RGBA(164, 180, 188, 1)
    }

    /// Returns brand gray color used in tabulator bar.
    class func tabBarGrayColor() -> UIColor {
        return RGBA(41, 41, 41, 1)
    }

    /// Returns brand background color used in collection view cells.
    class func cellBackgroundColor() -> UIColor {
        return RGBA(223, 224, 226, 1)
    }

    /// Returns brand gray color used for separator in shot details.
    class func separatorGrayColor() -> UIColor {
        return RGBA(218, 219, 221, 1)
    }

    /// Returns flash message gray background
    class func flashMessageBackgroundColor() -> UIColor {
        return RGBA(51, 51, 51, 1)
    }

    /// Returns random color.
    class func randomColor() -> UIColor {

        let red = Int(arc4random() % 256)
        let green = Int(arc4random() % 256)
        let blue = Int(arc4random() % 256)

        return RGBA(red, green, blue, 1)
    }
}
