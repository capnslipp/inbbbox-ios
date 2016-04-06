//
//  StringExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension String {
    
    /// Calculates bounding rect for given font, constrained to specifiec width.
    /// By default `CGFloat.max` is used as `height` parameter during calculations.
    /// - parameter font: Font to use as an attribute of string.
    /// - parameter constrainedToWidth: Maximum width of bounding rect.
    /// - Returns: Bounding rect.
    func boundingRectWithFont(font: UIFont, constrainedToWidth width: CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: CGFloat.max)
        let attributes = [NSFontAttributeName: font]
        let rect = NSString(string: self).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGRectIntegral(rect)
    }
}
