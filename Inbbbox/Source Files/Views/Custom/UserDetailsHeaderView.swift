//
//  UserDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

private var avatarSize: CGSize {
    return CGSize(width: 90, height: 90)
}
private var margin: CGFloat {
    return 10
}

class UserDetailsHeaderView: UICollectionReusableView {
    
    let avatarView = AvatarView(size: avatarSize, bordered: true, borderWidth: 3)
    let button = UIButton.newAutoLayoutView()
    var userFollowed: Bool? {
        didSet {
            let title = userFollowed! ? NSLocalizedString("Unfollow", comment: "") : NSLocalizedString("Follow", comment: "")
            button.setTitle(title, forState: .Normal)
        }
    }
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .pinkColor()
        clipsToBounds = true
        
        addSubview(avatarView)
        
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.RGBA(255, 255, 255, 0.2), forState: .Highlighted)
        button.titleLabel?.font = UIFont.helveticaFont(.Neue, size: 14)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 13
        addSubview(button)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true

            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoAlignAxisToSuperviewAxis(.Vertical)
            avatarView.autoAlignAxis(.Horizontal, toSameAxisOfView: avatarView.superview!, withOffset: -20)
//            avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: avatarView.superview!, withOffset: 10)
            
            button.autoSetDimensionsToSize(CGSize(width: 80, height: 26))
            button.autoPinEdge(.Top, toEdge: .Bottom, ofView: avatarView, withOffset: 10)
            button.autoAlignAxis(.Vertical, toSameAxisOfView: avatarView)
        }
        super.updateConstraints()
    }
}

extension UserDetailsHeaderView: Reusable {
    
    class var reuseIdentifier: String {
        return String(UserDetailsHeaderView)
    }
}
