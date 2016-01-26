//
//  NSAttributedStringExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    convenience init?(htmlString: String?) {
        
        guard let htmlString = htmlString else {
            return nil
        }
        
        let encodedData = htmlString.dataUsingEncoding(NSUTF8StringEncoding)!
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
    
}