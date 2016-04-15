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
    
    /// - returns: Attributed string by removing new line character at the end.
    func attributedStringByTrimingNewLineCharactersAtTheEnd() -> NSAttributedString {
        
        let possibleNewLineCharacter = string.substringFromIndex(string.endIndex.advancedBy(-1))
        if possibleNewLineCharacter == "\n" {
            let range = NSMakeRange(0, length - 1)
            return attributedSubstringFromRange(range).attributedStringByTrimingNewLineCharactersAtTheEnd()
        }

        return self
    }
    
    /// - returns: New line `\n` of type NSAttributedString.
    class func newLineAttributedString() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
    /// Calculates bounding height appropiate to available width.
    ///
    /// - parameter width: Available width.
    ///
    /// - returns: Bounding height.
    func boundingHeightUsingAvailableWidth(width: CGFloat) -> CGFloat {
        
        let options: NSStringDrawingOptions = [.UsesLineFragmentOrigin]
        
        return ceil(boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:options, context: nil).size.height)
    }
}
