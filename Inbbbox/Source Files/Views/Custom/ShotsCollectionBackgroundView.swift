//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionBackgroundView: UIView {

    let logoImageView = UIImageView(image: UIImage(named: "logo-type-shots"))
    private var didSetConstraints = false

//    MARK: - Life cycle

    convenience init() {
        self.init(frame: CGRectZero)

        backgroundColor = UIColor.backgroundGrayColor()

        logoImageView.configureForAutoLayout()
        addSubview(logoImageView)
    }

//    MAKR: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        if !didSetConstraints {
            logoImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 50)
            logoImageView.autoAlignAxisToSuperviewAxis(.Vertical)
            didSetConstraints = true
        }

        super.updateConstraints()
    }
}
