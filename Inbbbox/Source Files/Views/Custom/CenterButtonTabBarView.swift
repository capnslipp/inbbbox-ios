//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarView: UITabBar {

    private var didSetConstraints = false
    private var dummyItemScreenSizeDependentWidth: CGFloat {
        switch CGRectGetWidth(frame) {
            case 0..<375: return 60
            case 376..<100000: return 76
            default: return 70
        }
    }

    private(set) var likesItemViewVerticalConstraint: NSLayoutConstraint?
    private(set) var bucketsItemViewVerticalConstraint: NSLayoutConstraint?
    private(set) var followingItemViewVerticalConstraint: NSLayoutConstraint?
    private(set) var accountItemViewVerticalConstraint: NSLayoutConstraint?

    private let likesItemView = CustomTabBarItemView(name: "Likes", icon: UIImage(named: "ic-likes"))
    private let bucketsItemView = CustomTabBarItemView(name: "Buckets", icon: UIImage(named: "ic-buckets"))
    private let followingItemView = CustomTabBarItemView(name: "Following", icon: UIImage(named: "ic-following"))
    private let accountItemView = CustomTabBarItemView(name: "Account", icon: UIImage(named: "ic-account"))
    private let dummyItemView = CustomTabBarItemView(name: "", icon: nil)

//    MARK: - Life cycle

    @available(*, unavailable, message = "Use init() or init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        userInteractionEnabled = false

        likesItemView.configureForAutoLayout()
        addSubview(likesItemView)

        bucketsItemView.configureForAutoLayout()
        addSubview(bucketsItemView)
        
        dummyItemView.configureForAutoLayout()
        addSubview(dummyItemView)

        followingItemView.configureForAutoLayout()
        addSubview(followingItemView)

        accountItemView.configureForAutoLayout()
        addSubview(accountItemView)
    }

    override func updateConstraints() {

        if !didSetConstraints {
            didSetConstraints = true
            
            likesItemViewVerticalConstraint = likesItemView.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
            likesItemView.autoPinEdgeToSuperviewEdge(.Left)
            likesItemView.autoPinEdge(.Right, toEdge: .Left, ofView: bucketsItemView)

            bucketsItemViewVerticalConstraint = bucketsItemView.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
            bucketsItemView.autoPinEdge(.Right, toEdge: .Left, ofView: dummyItemView, withOffset: -3)
            bucketsItemView.autoMatchDimension(.Width, toDimension: .Width, ofView: likesItemView)

            dummyItemView.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
            dummyItemView.autoPinEdgeToSuperviewEdge(.Bottom)
            dummyItemView.autoAlignAxisToSuperviewAxis(.Vertical)
            dummyItemView.autoSetDimension(.Width, toSize: dummyItemScreenSizeDependentWidth)

            followingItemViewVerticalConstraint = followingItemView.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
            followingItemView.autoPinEdge(.Left, toEdge: .Right, ofView: dummyItemView, withOffset: 2.5)
            followingItemView.autoMatchDimension(.Width, toDimension: .Width, ofView: accountItemView)

            accountItemViewVerticalConstraint = accountItemView.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
            accountItemView.autoPinEdge(.Left, toEdge: .Right, ofView: followingItemView)
            accountItemView.autoPinEdgeToSuperviewEdge(.Right)
        }

        super.updateConstraints()
    }
}
