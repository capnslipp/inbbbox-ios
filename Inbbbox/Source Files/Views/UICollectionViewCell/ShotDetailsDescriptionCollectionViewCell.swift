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
        
        contentView.backgroundColor = UIColor.whiteColor()
        
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        separatorView.backgroundColor = .separatorGrayColor()
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
            
            let insets = self.dynamicType.contentInsets
            descriptionLabel.autoPinEdgesToSuperviewEdgesWithInsets(insets)
            
            separatorView.autoSetDimension(.Height, toSize: 1)
            separatorView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
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
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension ShotDetailsDescriptionCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsDescriptionCollectionViewCell)
    }
}
