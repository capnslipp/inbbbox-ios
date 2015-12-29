//
//  AutoScrollableCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit.UICollectionViewCell

class AutoScrollableCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            
            let imageViewConstraints = [
                NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: imageView.superview, attribute: .Left, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: imageView.superview, attribute: .Right, multiplier: 1, constant: 0),
            ]
            
            NSLayoutConstraint.activateConstraints(imageViewConstraints)
            
            didSetConstraints = true
        }

        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
