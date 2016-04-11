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
    weak var delegate: AvatarViewDelegate?
    private var avatarButton: UIButton
    
    convenience init (size: CGSize, bordered: Bool = true, borderWidth: CGFloat = 10) {
        self.init(avatarFrame: CGRect(origin: CGPointZero, size: size), bordered: bordered, borderWidth: borderWidth)
    }
    
    convenience init(avatarFrame: CGRect, bordered: Bool = true, borderWidth: CGFloat = 10) {
        self.init(frame: avatarFrame)
        if bordered {
            layer.cornerRadius = CGRectGetHeight(frame) * 0.5
            layer.shadowColor = UIColor(white: 1, alpha: 0.1).CGColor
            layer.shadowOffset = CGSizeZero
            layer.shadowRadius = 5
            layer.shadowOpacity = 1
            layer.borderColor = UIColor.whiteColor().CGColor
            layer.borderWidth = borderWidth
        }
    }
    
    private override init(frame: CGRect) {
        avatarButton = UIButton(frame: frame)
        super.init(frame: frame)
        imageView.frame.size = frame.size
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
        avatarButton.addTarget(self, action: #selector(didTapAvatarButton), forControlEvents: .TouchUpInside)
        addSubview(avatarButton)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAvatarButton() {
       delegate?.avatarView(self, didTapButton: avatarButton)
    }
}

protocol AvatarViewDelegate: class {
    func avatarView(avatarView: AvatarView, didTapButton avatarButton: UIButton)
}
