//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

//    MARK: - Life cycle

    @available(*, unavailable, message = "Use init() or init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
//        NGRTemp: temporary implementation
        setImage(UIImage(named: "ic-ball-active"), forState: .Normal)
    }

//    MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func intrinsicContentSize() -> CGSize {
//        NGRTemp: temporary implementation
        return CGSize(width: 100, height: 100)
    }
}
