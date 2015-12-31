//
//  UIImageExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 31/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func referenceImageWithColor(color: UIColor) -> UIImage {
        return UIImage.imageWithColor(color, size: CGSize(width: 1, height: 1))
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
