//
//  RoundedView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 29.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {

    internal var cornersToRound = UIRectCorner()
    internal var radiusToSet: CGFloat = 0

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable, message = "Use init(frame: CGRect)")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public
    
    /**
        Updates view by applying radius (CGFloat)
        to specified corners (UIRectCorner).
        Mask, with rounded corners, is applied in drawRect(rect: CGRect) method.
    */
    func update(byRoundingCorners: UIRectCorner, radius: CGFloat) {
        cornersToRound = byRoundingCorners
        radiusToSet = radius
        setNeedsDisplay()
    }

    // MARK: Internal

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornersToRound, cornerRadii: CGSize(width: radiusToSet, height: radiusToSet))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
    }
}
