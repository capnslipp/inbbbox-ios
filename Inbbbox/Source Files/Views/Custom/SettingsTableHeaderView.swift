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
    
    private var avatarView: AvatarView!
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
        
        avatarView = AvatarView(frame: CGRect(x: CGRectGetWidth(frame)/2 - 75, y: 10, width: 150, height: 150))// NGRTemp: temp frame
        
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        avatarView.imageView.image = UIImage() //NGRFix: provide the image
        avatarView.imageView.backgroundColor = UIColor.lightGrayColor() // NGRTemp: temp color
        
        userName.frame = CGRect(x: CGRectGetWidth(frame)/2 - 100, y: 160, width: 200, height: 30) // NGRTemp: temp frame
        userName.text = "Scarlett Johansson" //NGRFix: provide the name
        
        addSubview(avatarView)
        addSubview(userName)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
