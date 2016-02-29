//
//  ShotBucketsView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 24/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

class ShotBucketsView: UIView {
    
    let collectionView: UICollectionView
    let closeButton = UIButton(type: .System)
    
    var topLayoutGuideOffset = CGFloat(0)
    
    private let collectionViewCornerWrapperView = UIView.newAutoLayoutView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ShotDetailsCollectionCollapsableViewStickyHeader())
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.layer.shadowColor = UIColor.grayColor().CGColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        collectionView.layer.shadowOpacity = 0.3
        collectionView.clipsToBounds = true
        
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        
        blurView.configureForAutoLayout()
        addSubview(blurView)
        
        collectionViewCornerWrapperView.backgroundColor = .clearColor()
        collectionViewCornerWrapperView.clipsToBounds = true
        collectionViewCornerWrapperView.addSubview(collectionView)
        
        addSubview(collectionViewCornerWrapperView)
        
        let image = UIImage(named: "ic-closemodal")?.imageWithRenderingMode(.AlwaysOriginal)
        closeButton.setImage(image, forState: .Normal)
        addSubview(closeButton)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            blurView.autoPinEdgesToSuperviewEdges()
            
            let insets = UIEdgeInsets(top: topLayoutGuideOffset, left: 10, bottom: 0, right: 10)
            collectionViewCornerWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(insets, excludingEdge: .Bottom)
            collectionViewCornerWrapperView.autoPinEdgeToSuperviewEdge(.Bottom)
            
            collectionView.autoPinEdgesToSuperviewEdges()
            
            let margin = CGFloat(5)
            closeButton.autoSetDimensionsToSize(closeButton.imageForState(.Normal)?.size ?? CGSizeZero)
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: collectionViewCornerWrapperView, withOffset: -margin)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: collectionViewCornerWrapperView, withOffset: margin)
        }
        
        super.updateConstraints()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let path = UIBezierPath(roundedRect: collectionViewCornerWrapperView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        collectionViewCornerWrapperView.layer.mask = mask
    }
}
