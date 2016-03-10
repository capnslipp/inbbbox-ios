//
//  ShotBucketsSeparatorCollectionViewCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 25/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotBucketsSeparatorCollectionViewCell: UICollectionViewCell {
    
    private let cellHeight = CGFloat(20)
    
    private let topSeparatorLine = UIView.newAutoLayoutView()
    private let bottomSeparatorLine = UIView.newAutoLayoutView()
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureForAutoLayout()
        
        contentView.configureForAutoLayout()
        contentView.backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        
        topSeparatorLine.configureForAutoLayout()
        topSeparatorLine.backgroundColor = .RGBA(223, 224, 226, 1)
        contentView.addSubview(topSeparatorLine)
        
        bottomSeparatorLine.configureForAutoLayout()
        bottomSeparatorLine.backgroundColor = .RGBA(223, 224, 226, 1)
        contentView.addSubview(bottomSeparatorLine)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let separatorLineHeight = CGFloat(0.5)
            
            topSeparatorLine.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            topSeparatorLine.autoSetDimension(.Height, toSize: separatorLineHeight)
            
            bottomSeparatorLine.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            bottomSeparatorLine.autoSetDimension(.Height, toSize: separatorLineHeight)
            
            contentView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        layoutAttributes.frame = {
            
            var frame = layoutAttributes.frame
            frame.size.height = cellHeight
            
            return CGRectIntegral(frame)
            }()
        
        return layoutAttributes
    }
}

extension ShotBucketsSeparatorCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotBucketsSeparatorCollectionViewCell)
    }
}
