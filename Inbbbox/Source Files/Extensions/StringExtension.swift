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
    
    static func randomAlphanumericString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters
        let lettersLength = UInt32(letters.count)
        
        let randomCharacters = (0..<length).map { i -> String in
            let offset = Int(arc4random_uniform(lettersLength))
            let c = letters[letters.startIndex.advancedBy(offset)]
            return String(c)
        }
        
        return randomCharacters.joinWithSeparator("")
    }
}
