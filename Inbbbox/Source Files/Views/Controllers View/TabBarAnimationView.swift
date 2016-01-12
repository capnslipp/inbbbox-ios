//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TabBarAnimationView: UIView {

//    MARK: - Life cycle

    let tabBar = UITabBar.newAutoLayoutView()
    private(set) var tabBarVerticalConstraint: NSLayoutConstraint?
    private var didSetConstraints = false

    @available(*, unavailable, message = "Use init() or init(collectionViewLayout:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.backgroundGrayColor()

        addSubview(tabBar)
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        if !didSetConstraints {
            tabBarVerticalConstraint = tabBar.autoPinEdge(.Top, toEdge: .Bottom, ofView: self)
            tabBar.autoPinEdgeToSuperviewEdge(.Left)
            tabBar.autoPinEdgeToSuperviewEdge(.Right)
        }

        super.updateConstraints()
    }
}
