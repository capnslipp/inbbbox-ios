//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarView: UITabBar {

//    MARK: - Life cycle

    private var didSetConstraints = false
    let centerButton = RoundedButton()

    @available(*, unavailable, message = "Use init() or init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let likesTabBarItem = UITabBarItem(title: "Likes", image: UIImage(named: "ic-likes"), selectedImage: UIImage(named: "ic-likes-active"))
        let bucketsTabBarItem = UITabBarItem(title: "Buckets", image: UIImage(named: "ic-buckets"), selectedImage: UIImage(named: "ic-buckets-active"))
        let centerButtonPlaceholderTabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        let followingTabBarItem = UITabBarItem(title: "Following", image: UIImage(named: "ic-following"), selectedImage: UIImage(named: "ic-following-active"))
        let accountTabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "ic-account"), selectedImage: UIImage(named: "ic-account-active"))
        items = [likesTabBarItem, bucketsTabBarItem, centerButtonPlaceholderTabBarItem, followingTabBarItem, accountTabBarItem]

        centerButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(centerButton)
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

        if !didSetConstraints {
            centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
            centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset:8.0)
            didSetConstraints = true
        }

        super.updateConstraints()
    }
}
