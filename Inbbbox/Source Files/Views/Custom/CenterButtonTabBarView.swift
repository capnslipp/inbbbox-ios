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

        likesItemView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(likesItemView)

        bucketsItemView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bucketsItemView)

        centerButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(centerButton)

        followingItemView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(followingItemView)

        accountItemView.translatesAutoresizingMaskIntoConstraints = false
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
        //NGRTodo: Implementation needed

        if !didSetConstraints {
            centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
            centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset:8.0)
            didSetConstraints = true
        }

        super.updateConstraints()
    }
}
