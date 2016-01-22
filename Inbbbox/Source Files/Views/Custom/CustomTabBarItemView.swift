//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CustomTabBarItemView: UIView {

    private var didSetConstraints = false
    let nameLabel = UILabel()
    let iconImageView = UIImageView()

//    MARK: - Life cycle

    init(name: String?, icon: UIImage?) {
        super.init(frame: CGRectZero)
        
        nameLabel.font = UIFont.systemFontOfSize(10)
        nameLabel.textColor = UIColor.tabBarGrayColor()
        nameLabel.text = name
        addSubview(nameLabel)
        nameLabel.configureForAutoLayout()

        iconImageView.image = icon?.imageWithRenderingMode(.AlwaysOriginal)
        addSubview(iconImageView)
        iconImageView.configureForAutoLayout()
    }
    
    @available(*, unavailable, message="Use init(name:icon:) instead")
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message="Use init(name:icon:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    MARK: - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {

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
