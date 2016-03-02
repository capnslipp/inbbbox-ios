//
//  ShotBucketsHeaderView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 24/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

private var avatarSize: CGSize {
    return CGSize(width: 40, height: 40)
}
private var margin: CGFloat {
    return 10
}

class ShotBucketsHeaderView: UICollectionReusableView {
    
    var availableWidthForTitle: CGFloat {
        return avatarSize.width + 3 * margin
    }
    
    var maxHeight = CGFloat(0)
    var minHeight = CGFloat(0)
    
    let imageView = ShotImageView.newAutoLayoutView()
    let avatarView = AvatarView(size: avatarSize, bordered: false)
    
    private let headerTitleLabel = UILabel.newAutoLayoutView()
    private let titleLabel = UILabel.newAutoLayoutView()
    
    private let dimView = UIView.newAutoLayoutView()
    private let imageViewCenterWrapperView = UIView.newAutoLayoutView()
    
    private var imageViewCenterWrapperViewBottomEdgeConstraint: NSLayoutConstraint?
    
    private var didUpdateConstraints = false
    private var collapseProgress: CGFloat {
        return 1 - (frame.size.height - minHeight) / (maxHeight - minHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .RGBA(246, 248, 248, 1)
        clipsToBounds = true
        
        titleLabel.backgroundColor = .clearColor()
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        addSubview(avatarView)
        
        imageViewCenterWrapperView.addSubview(imageView)
        imageViewCenterWrapperView.clipsToBounds = true
        
        addSubview(imageViewCenterWrapperView)
        
        dimView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        dimView.alpha = 0
        imageViewCenterWrapperView.addSubview(dimView)
        
        headerTitleLabel.backgroundColor = .clearColor()
        headerTitleLabel.textColor = .whiteColor()
        headerTitleLabel.font = .helveticaFont(.NeueMedium, size: 16)
        addSubview(headerTitleLabel)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let progress = collapseProgress
        let absoluteProgress = max(min(progress, 1), 0)
        
        imageViewCenterWrapperViewBottomEdgeConstraint?.constant = -minHeight + minHeight * absoluteProgress
        
        dimView.alpha = 0.3 + 0.7 * progress

    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let topHeaderLabelInset = CGFloat(10)
            headerTitleLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            headerTitleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: topHeaderLabelInset)
            
            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: minHeight * 0.5 - avatarSize.height * 0.5)
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            
            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: margin)
            titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            titleLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            titleLabel.autoSetDimension(.Height, toSize: minHeight)
            
            imageViewCenterWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            imageViewCenterWrapperViewBottomEdgeConstraint = imageViewCenterWrapperView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: minHeight)
            
            imageView.autoMatchDimension(.Width, toDimension: .Width, ofView: imageViewCenterWrapperView)
            imageView.autoCenterInSuperview()
            
            dimView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
    }
    
    func setAttributedTitle(title: NSAttributedString?) {
        titleLabel.attributedText = title
    }
    
    func setHeaderTitle(title: String) {
        headerTitleLabel.text = title
    }
}

extension ShotBucketsHeaderView: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotBucketsHeaderView)
    }
}

