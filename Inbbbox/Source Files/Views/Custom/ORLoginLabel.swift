//
//  ORLoginLabel.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ORLoginLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .Center
        textColor = UIColor.RGBA(249, 212, 226, 1)
        font = UIFont.helveticaFont(.NeueMedium, size: 11)
        text = NSLocalizedString("OR", comment: "")
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let boundingTextRect = text?.boundingRectWithFont(font!, constrainedToWidth: CGRectGetWidth(rect)) ?? CGRectZero
        let space = CGFloat(10)
        let y = CGRectGetMidY(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, textColor!.CGColor)
        CGContextSetLineWidth(context, 1)
        
        CGContextMoveToPoint(context, 0, y)
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) - CGRectGetWidth(boundingTextRect) * 0.5 - space, y)
        
        CGContextMoveToPoint(context, CGRectGetMidX(rect) + CGRectGetWidth(boundingTextRect) * 0.5 + space, y)
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), y)
        
        CGContextStrokePath(context)
    }
}
