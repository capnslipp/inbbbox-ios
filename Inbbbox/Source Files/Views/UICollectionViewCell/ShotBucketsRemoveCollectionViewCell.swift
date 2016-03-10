//
//  ShotBucketsRemoveCollectionViewCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 25/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotBucketsRemoveCollectionViewCell: UICollectionViewCell {
    
    let removeButton = UIButton.newAutoLayoutView()
    
    private let cellHeight = CGFloat(44)
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureForAutoLayout()
        
        contentView.configureForAutoLayout()
        contentView.backgroundColor = .whiteColor()
        
        removeButton.configureForAutoLayout()
        removeButton.setTitle(NSLocalizedString("Remove From Selected Buckets", comment: ""), forState: .Normal)
        removeButton.setTitleColor(.pinkColor(), forState: .Normal)
        removeButton.titleLabel?.font = UIFont.helveticaFont(.Neue, size: 16)
        contentView.addSubview(removeButton)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            removeButton.autoPinEdgesToSuperviewEdges()
            
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

extension ShotBucketsRemoveCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotBucketsRemoveCollectionViewCell)
    }
}
