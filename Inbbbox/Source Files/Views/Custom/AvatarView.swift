//
//  AvatarView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension AvatarView {
    
    func commonInit() {
        
        imageView.frame.size = frame.size
        
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        imageView.contentMode = .ScaleAspectFit
        
        layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        layer.shadowColor = UIColor.RGBA(0, 0, 0, 0.1).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 10
        
        addSubview(imageView)
    }
}
