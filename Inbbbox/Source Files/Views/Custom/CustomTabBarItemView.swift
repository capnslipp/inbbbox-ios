//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CustomTabBarItemView: UIView {

    private var didSetConstraints = false
    let nameLabel = UILabel()
    let iconImageView = UIImageView()

//    MARK: - Life cycle

    convenience init(name: String?, icon: UIImage?) {
        self.init(frame: CGRectZero)
        nameLabel.text = name
        iconImageView.image = icon

        addSubview(nameLabel)
        nameLabel.configureForAutoLayout()
        addSubview(iconImageView)
        iconImageView.configureForAutoLayout()
    }

//    MARK: - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {

//        NGRTemp: temporary implementation

        if !didSetConstraints {
            iconImageView.autoPinEdgeToSuperviewEdge(.Top)
            iconImageView.autoAlignAxisToSuperviewAxis(.Vertical)
            nameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: iconImageView, withOffset: 5.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            nameLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            didSetConstraints = true
        }
        
        super.updateConstraints()
    }
}
