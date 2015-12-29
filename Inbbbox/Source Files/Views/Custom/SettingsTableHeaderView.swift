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
    
    private let avatarSize = CGSize(width: 176, height: 176)
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: avatarSize))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(size: CGSize) {
        self.init(frame: CGRect(origin: CGPointZero, size: size))
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 20)
            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoAlignAxisToSuperviewAxis(.Vertical)
            
            userName.autoPinEdge(.Top, toEdge: .Bottom, ofView: avatarView, withOffset: 14)
            userName.autoSetDimension(.Height, toSize: 28)
            userName.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            userName.autoAlignAxis(.Vertical, toSameAxisOfView: avatarView)
        }
        
        super.updateConstraints()
    }
}

private extension SettingsTableHeaderView {
    
    func commonInit() {
        
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        if let data = NSData(contentsOfURL: NSURL(string: "https://www.gravatar.com/avatar/348f80fa39b3d1d66bd68440ea229192?s=200")!) { // NGRTemp: will be removed
            avatarView.imageView.image = UIImage(data: data) //NGRFix: provide the image
        }
        avatarView.imageView.backgroundColor = UIColor.lightGrayColor() // NGRTemp: temp color
        
        userName.textAlignment = .Center
        userName.text = "joke1410" //NGRFix: provide the name
        userName.textColor = UIColor.textDarkColor()
        userName.font = UIFont(name: "HelveticaNeue", size: 23)
        
        addSubview(avatarView)
        addSubview(userName)
        
        setNeedsUpdateConstraints()
    }
}
