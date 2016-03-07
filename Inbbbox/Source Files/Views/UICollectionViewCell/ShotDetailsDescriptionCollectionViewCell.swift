//
//  ShotDetailsDescriptionCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
import UIKit

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
        
        let insets = self.dynamicType.contentInsets
        descriptionLabel.preferredMaxLayoutWidth = frame.size.width - insets.left - insets.right
    }

    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            descriptionLabel.autoPinEdgesToSuperviewEdgesWithInsets(self.dynamicType.contentInsets)
            
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

extension ShotDetailsDescriptionCollectionViewCell: AutoSizable {
        
    static var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
}

extension ShotDetailsDescriptionCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsDescriptionCollectionViewCell)
    }
}
