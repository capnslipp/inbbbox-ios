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
    
    convenience init (size: CGSize, bordered: Bool = true) {
        self.init(avatarFrame: CGRect(origin: CGPointZero, size: size), bordered: bordered)
    }
    
    convenience init(avatarFrame: CGRect, bordered: Bool = true) {
        self.init(frame: avatarFrame)
        if bordered {
            layer.cornerRadius = CGRectGetHeight(frame) * 0.5
            layer.shadowColor = UIColor(white: 1, alpha: 0.1).CGColor
            layer.shadowOffset = CGSizeZero
            layer.shadowRadius = 5
            layer.shadowOpacity = 1
            layer.borderColor = UIColor.whiteColor().CGColor
            layer.borderWidth = 10
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame.size = frame.size
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
