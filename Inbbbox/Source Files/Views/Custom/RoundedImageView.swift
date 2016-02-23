//
//  RoundedImageView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class RoundedImageView: UIView {
    
    private var didUpdateConstraints = false
    private let imageView: UIImageView
    private var cornersToRound = UIRectCorner()
    private var radiusToSet: CGFloat
    private var dimnessView: UIView
    
    // Constraints
    private var dimnessViewConstraints: [NSLayoutConstraint]?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        imageView = UIImageView.newAutoLayoutView()
        dimnessView = UIView.newAutoLayoutView()
        radiusToSet = 0
        
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(dimnessView)
    }
    
    @available(*, unavailable, message = "Use init(withImage:, byRoundingCorners:, radius:, frame:")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func updateWith(imageUrl: String, byRoundingCorners: UIRectCorner, radius: CGFloat) {
        imageView.loadImageFromURLString(imageUrl)
        cornersToRound = byRoundingCorners
        radiusToSet = radius
        setNeedsDisplay()
    }
    
    func updateRadius(radius: CGFloat) {
        radiusToSet = radius
        setNeedsDisplay()
    }
    
    func updateFitting(mode: UIViewContentMode) {
        imageView.contentMode = mode
        dimnessView.backgroundColor = UIColor.RGBA(0, 0, 0, 0.1)
        setNeedsDisplay()
    }
    
    func useDimness(value: Bool, alpha: CGFloat = 0.1) {
        dimnessView.backgroundColor = value ? UIColor.RGBA(0, 0, 0, alpha) : UIColor.clearColor()
    }
    
    // MARK: Internal
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornersToRound, cornerRadii: CGSize(width: radiusToSet, height: radiusToSet))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
    }
    
    // MARK: Auto Layout
    override func updateConstraints() {
        if !didUpdateConstraints {
            imageView.autoPinEdgesToSuperviewEdges()
            dimnessView.autoPinEdgesToSuperviewEdges()
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
}
