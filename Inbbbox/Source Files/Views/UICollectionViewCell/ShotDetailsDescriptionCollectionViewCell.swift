//
//  ShotDetailsDescriptionCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
import UIKit

private var inset: CGPoint {
    return CGPoint(x: 10, y: 15)
}

class ShotDetailsDescriptionCollectionViewCell: UICollectionViewCell {
    
    let descriptionLabel = UILabel.newAutoLayoutView()
    private let separatorView = UIView.newAutoLayoutView()
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        separatorView.backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        contentView.addSubview(separatorView)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptionLabel.preferredMaxLayoutWidth = frame.size.width - 2 * inset.x
    }

    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let insets = UIEdgeInsets(top: inset.y, left: inset.x, bottom: inset.y, right: inset.x)
            descriptionLabel.autoPinEdgesToSuperviewEdgesWithInsets(insets)
            
            separatorView.autoSetDimension(.Height, toSize: 1)
            separatorView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        }
        
        super.updateConstraints()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        layoutAttributes.frame = {
            
            var frame = layoutAttributes.frame
            frame.size.height = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            
            return CGRectIntegral(frame)
        }()

        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        descriptionLabel.attributedText = nil
    }
}

extension ShotDetailsDescriptionCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsDescriptionCollectionViewCell)
    }
}
