//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CustomTabBarItemView: UIView {

    private var didSetConstraints = false
    let nameLabel = UILabel()
    let iconImageView = UIImageView()

    convenience init(name: String?, icon: UIImage?) {
        self.init(frame: CGRectZero)
        nameLabel.text = name
        iconImageView.image = icon
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {
        //NGRTodo: Implementation needed

        if !didSetConstraints {

        }

        super.updateConstraints()
    }
}
