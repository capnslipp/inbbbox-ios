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
    private let cornersToRound: UIRectCorner
    private var radiusToSet: CGFloat
    
    // MARK: Life Cycle
    
    init(image: UIImage, byRoundingCorners: UIRectCorner, radius: CGFloat, frame: CGRect) {
        imageView = UIImageView.newAutoLayoutView()
        imageView.image = image
        cornersToRound = byRoundingCorners
        radiusToSet = radius
        
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    @available(*, unavailable, message = "Use init(withImage:, byRoundingCorners:, radius:, frame:")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message = "Use init(withImage:, byRoundingCorners:, radius:, frame:")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
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
