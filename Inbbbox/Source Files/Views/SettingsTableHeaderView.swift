//
//  SettingsTableHeaderView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsTableHeaderView: UIView, Reusable {
    
    class var reuseIdentifier: String {
        return "SettingsTableHeaderViewReuseIdentifier"
    }
    
    private let avatarView = AvatarView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    private let userName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension SettingsTableHeaderView {
    
    func commonInit() {
        
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        avatarView.imageView.image = UIImage() //NGRFix: provide the image

        addSubview(avatarView)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}