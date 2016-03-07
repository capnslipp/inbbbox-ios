//
//  NSAttributedStringExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    convenience init?(htmlString: String) {
        
        guard let encodedData = htmlString.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        var attributedString: NSAttributedString?
        
        do {
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        } catch {
            return nil
        }
        
        self.init(attributedString: attributedString!)
    }
    
    func attributedStringByTrimingNewLineCharactersAtTheEnd() -> NSAttributedString {
        
        let possibleNewLineCharacter = string.substringFromIndex(string.endIndex.advancedBy(-1))
        if possibleNewLineCharacter == "\n" {
            let range = NSMakeRange(0, length - 1)
            return attributedSubstringFromRange(range).attributedStringByTrimingNewLineCharactersAtTheEnd()
        }

        return self
    }
    
    class func newLineAttributedString() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
    func boundingHeightUsingAvailableWidth(width: CGFloat) -> CGFloat {
        
        let options = unsafeBitCast(
            NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue,
            NSStringDrawingOptions.self
        )
        return ceil(boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:options, context:nil).size.height)
    }
}
