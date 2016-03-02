//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

//    MARK: - Life cycle

    let diameter = CGFloat(70)
    
    @available(*, unavailable, message = "Use init() or init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = diameter/2
        layer.shadowColor = UIColor.RGBA(0, 0, 0, 0.09).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }

//    MARK: - UIView

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: diameter, height: diameter)
    }
}
