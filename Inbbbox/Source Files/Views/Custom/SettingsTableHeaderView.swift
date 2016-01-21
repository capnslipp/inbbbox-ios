//
//  SettingsTableHeaderView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

class SettingsTableHeaderView: UIView, Reusable {
    
    class var reuseIdentifier: String {
        return "SettingsTableHeaderViewReuseIdentifier"
    }
    
    private(set) var avatarView: AvatarView!
    private(set) var usernameLabel = UILabel.newAutoLayoutView()
    
    private let avatarSize = CGSize(width: 176, height: 176)
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: avatarSize))
        avatarView.imageView.backgroundColor = UIColor.backgroundGrayColor()
        addSubview(avatarView)
        
        usernameLabel.textAlignment = .Center
        usernameLabel.textColor = UIColor.textDarkColor()
        usernameLabel.font = UIFont.helveticaFont(.Neue, size: 23)
        addSubview(usernameLabel)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(_: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGSize) {
        self.init(frame: CGRect(origin: CGPointZero, size: size))
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoAlignAxisToSuperviewAxis(.Vertical)
            
            usernameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: avatarView, withOffset: 14)
            usernameLabel.autoSetDimension(.Height, toSize: 28)
            usernameLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            usernameLabel.autoAlignAxis(.Vertical, toSameAxisOfView: avatarView)
        }
        
        super.updateConstraints()
    }
}
