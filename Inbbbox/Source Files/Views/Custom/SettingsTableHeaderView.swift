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
        
        avatarView = AvatarView(frame: CGRect(x: CGRectGetWidth(frame)/2 - (176/2), y: 38, width: 176, height: 176))// NGRTemp: temp frame
        
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        if let data = NSData(contentsOfURL: NSURL(string: "https://www.gravatar.com/avatar/348f80fa39b3d1d66bd68440ea229192?s=200")!) { // NGRTemp: will be removed
            avatarView.imageView.image = UIImage(data: data) //NGRFix: provide the image
        }
        avatarView.imageView.backgroundColor = UIColor.lightGrayColor() // NGRTemp: temp color
        
        userName.frame = CGRect(x: CGRectGetWidth(frame)/2 - 100, y: 228, width: 200, height: 28) // NGRTemp: temp frame
        userName.textAlignment = .Center
        userName.text = "joke1410" //NGRFix: provide the name
        userName.textColor = UIColor.textDarkColor()
        
        addSubview(avatarView)
        addSubview(userName)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
