//
//  ShotDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
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

class ShotDetailsHeaderView: UICollectionReusableView {
    
    var availableWidthForTitle: CGFloat {
        return avatarSize.width + 3 * margin
    }
    
    var maxHeight = CGFloat(0)
    var minHeight = CGFloat(0)
    
    var imageView: UIImageView!
    let avatarView = AvatarView(size: avatarSize, bordered: false)
    
    private let titleLabel = UILabel.newAutoLayoutView()
    private let overlapingTitleLabel = UILabel.newAutoLayoutView()
    private let dimView = UIView.newAutoLayoutView()
    private let imageViewCenterWrapperView = UIView.newAutoLayoutView()
    
    private var imageViewCenterWrapperViewBottomEdgeConstraint: NSLayoutConstraint?
    
    private var didUpdateConstraints = false
    private var collapseProgress: CGFloat {
        return 1 - (frame.size.height - minHeight) / (maxHeight - minHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        clipsToBounds = true
        
        titleLabel.backgroundColor = .clearColor()
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        imageViewCenterWrapperView.clipsToBounds = true
        addSubview(imageViewCenterWrapperView)
        
        dimView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        dimView.alpha = 0
        imageViewCenterWrapperView.addSubview(dimView)
        
        overlapingTitleLabel.backgroundColor = .clearColor()
        overlapingTitleLabel.numberOfLines = 0
        overlapingTitleLabel.alpha = 0
        addSubview(overlapingTitleLabel)
        
        addSubview(avatarView)
        
        setNeedsUpdateConstraints()
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
        
        dimView.alpha = progress
        overlapingTitleLabel.alpha = progress
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: minHeight * 0.5 - avatarSize.height * 0.5)
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            
            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: margin)
            titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            titleLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            titleLabel.autoSetDimension(.Height, toSize: minHeight)
            
            overlapingTitleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: margin)
            overlapingTitleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            overlapingTitleLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            overlapingTitleLabel.autoSetDimension(.Height, toSize: minHeight)
            
            imageViewCenterWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            imageViewCenterWrapperViewBottomEdgeConstraint = imageViewCenterWrapperView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: minHeight)
            
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
        overlapingTitleLabel.attributedText = {
            guard let title = title else {
                return nil
            }
            
            let mutableTitle = NSMutableAttributedString(attributedString: title)
            let range = NSMakeRange(0, title.length)
            mutableTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            
            return mutableTitle.copy() as? NSAttributedString
        }()
    }
}

extension ShotDetailsHeaderView {
    
    func setImageWithUrl(url: NSURL) {
        if imageView == nil {
            imageView = ShotImageView.newAutoLayoutView()
            setupImageView()
        }
        let iv = imageView as! ShotImageView
        iv.loadImageFromURL(url)
    }
    
    func setAnimatedImageWithUrl(url: NSURL) {
        if imageView == nil {
            imageView = AnimatableShotImageView.newAutoLayoutView()
            setupImageView()
        }
        let iv = imageView as! AnimatableShotImageView
        iv.loadAnimatableShotFromUrl(url)
    }
    
    private func setupImageView() {
        imageViewCenterWrapperView.insertSubview(imageView, belowSubview: dimView)
        imageView.autoMatchDimension(.Width, toDimension: .Width, ofView: imageViewCenterWrapperView)
        imageView.autoCenterInSuperview()
    }
}

extension ShotDetailsHeaderView: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsHeaderView)
    }
}
