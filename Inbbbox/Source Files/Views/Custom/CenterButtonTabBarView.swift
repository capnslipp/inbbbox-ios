//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarView: UITabBar {

    private var didSetConstraints = false
    let likesItemView = CustomTabBarItemView(name: "Likes", icon: UIImage(named: "ic-likes"))
    let bucketsItemView = CustomTabBarItemView(name: "Buckets", icon: UIImage(named: "ic-buckets"))
    let centerButton = RoundedButton()
    let followingItemView = CustomTabBarItemView(name: "Following", icon: UIImage(named: "ic-following"))
    let accountItemView = CustomTabBarItemView(name: "Account", icon: UIImage(named: "ic-account"))

//    MARK: - Life cycle

    @available(*, unavailable, message = "Use init() or init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        likesItemView.configureForAutoLayout()
        addSubview(likesItemView)

        bucketsItemView.configureForAutoLayout()
        addSubview(bucketsItemView)

        centerButton.configureForAutoLayout()
        centerButton.setImage(UIImage(named: "ic-ball-active"), forState: .Normal)
        centerButton.backgroundColor = UIColor.whiteColor()
        addSubview(centerButton)

        followingItemView.configureForAutoLayout()
        addSubview(followingItemView)

        accountItemView.configureForAutoLayout()
        addSubview(accountItemView)
    }

//    MARK: - UIView

    override func addSubview(view: UIView) {
        super.addSubview(view)

        bringSubviewToFront(centerButton)
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

//        NGRTemp: temporary implementation

        if !didSetConstraints {
            likesItemView.autoAlignAxisToSuperviewAxis(.Horizontal)
            likesItemView.autoPinEdgeToSuperviewEdge(.Left)
            likesItemView.autoPinEdge(.Right, toEdge: .Left, ofView: bucketsItemView)

            bucketsItemView.autoAlignAxisToSuperviewAxis(.Horizontal)
            bucketsItemView.autoPinEdge(.Left, toEdge: .Right, ofView: likesItemView)
            bucketsItemView.autoPinEdge(.Right, toEdge: .Left, ofView: centerButton)
            bucketsItemView.autoMatchDimension(.Width, toDimension: .Width, ofView: likesItemView)
            
            centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
            centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset:8.0)
            
            followingItemView.autoAlignAxisToSuperviewAxis(.Horizontal)
            followingItemView.autoPinEdge(.Left, toEdge: .Right, ofView: centerButton)
            followingItemView.autoPinEdge(.Right, toEdge: .Left, ofView: accountItemView)
            
            accountItemView.autoAlignAxisToSuperviewAxis(.Horizontal)
            accountItemView.autoPinEdge(.Left, toEdge: .Right, ofView: followingItemView)
            accountItemView.autoPinEdgeToSuperviewEdge(.Right)
            accountItemView.autoMatchDimension(.Width, toDimension: .Width, ofView: followingItemView)

            didSetConstraints = true
        }

        super.updateConstraints()
    }
}
