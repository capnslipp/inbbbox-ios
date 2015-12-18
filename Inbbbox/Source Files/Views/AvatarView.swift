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
        
        imageView.contentMode = .ScaleAspectFit
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.shadowColor = UIColor.grayColor().CGColor
        addSubview(imageView)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
