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
        self.items = [likesTabBarItem, bucketsTabBarItem, centerButtonPlaceholderTabBarItem, followingTabBarItem, accountTabBarItem]

        centerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(centerButton)
    }

//    MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        if !didSetConstraints {
            centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
            centerButton.autoPinEdgeToSuperviewEdge(.Bottom)
        }

        super.updateConstraints()
    }
}
