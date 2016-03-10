//
//  StringExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension String {
    
    func boundingRectWithFont(font: UIFont, constrainedToWidth width: CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: CGFloat.max)
        let attributes = [NSFontAttributeName: font]
        let rect = NSString(string: self).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGRectIntegral(rect)
    }
}
