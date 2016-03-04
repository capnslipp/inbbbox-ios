//
//  ShotDetailsFooterView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 02/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

private var cornerRadius: CGFloat {
    return 30
}

private var spaceBetweenBottomEdgeOfFooterAndCollectionView: CGFloat {
    return 20
}

class ShotDetailsFooterView: UICollectionReusableView {
    
    class var minimumRequiredHeight: CGFloat {
        return cornerRadius + spaceBetweenBottomEdgeOfFooterAndCollectionView
    }
    
    private var didUpdateConstraints = false
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private let cornerWrapperView = UIView.newAutoLayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        
        activityIndicatorView.configureForAutoLayout()
        activityIndicatorView.backgroundColor = .clearColor()
        activityIndicatorView.color = .grayColor()
        
        cornerWrapperView.backgroundColor = .RGBA(255, 255, 255, 1)
        cornerWrapperView.addSubview(activityIndicatorView)
        addSubview(cornerWrapperView)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: cornerWrapperView.frame, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            cornerWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            cornerWrapperView.autoSetDimension(.Height, toSize: spaceBetweenBottomEdgeOfFooterAndCollectionView)
            
            activityIndicatorView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
    func grayOutBackground() {
        cornerWrapperView.backgroundColor = .RGBA(246, 248, 248, 1)
    }
}

extension ShotDetailsFooterView: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsFooterView)
    }
}
