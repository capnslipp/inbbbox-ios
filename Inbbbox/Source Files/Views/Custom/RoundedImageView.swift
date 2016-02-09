//
//  RoundedImageView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoundedImageView: UIView {
    
    private var didUpdateConstraints = false
    private let imageView: UIImageView
    private var cornersToRound = UIRectCorner()
    private var radiusToSet: CGFloat
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        imageView = UIImageView.newAutoLayoutView()
        radiusToSet = 0
        
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    @available(*, unavailable, message = "Use init(withImage:, byRoundingCorners:, radius:, frame:")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func updateWith(image: UIImage, byRoundingCorners: UIRectCorner, radius: CGFloat) {
        imageView.image = image
        cornersToRound = byRoundingCorners
        radiusToSet = radius
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
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
}
