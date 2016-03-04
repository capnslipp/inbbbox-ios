//
//  ShotDetailsDescriptionCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
import UIKit

class ShotDetailsDescriptionCollectionViewCell: UICollectionViewCell {
    
    class var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
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
        
        let insets = self.dynamicType.insets
        descriptionLabel.preferredMaxLayoutWidth = frame.size.width - insets.left - insets.right
    }

    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            descriptionLabel.autoPinEdgesToSuperviewEdgesWithInsets(self.dynamicType.insets)
            
            separatorView.autoSetDimension(.Height, toSize: 1)
            separatorView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        }
        
        super.updateConstraints()
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
