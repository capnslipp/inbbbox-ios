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

        let maskLayer = CAShapeLayer()
        let maskRect = CGRect(x: 0, y: 0, width: intrinsicContentSize().width, height: intrinsicContentSize().height)
        let ovalPath = UIBezierPath(ovalInRect: maskRect)
        maskLayer.path = ovalPath.CGPath
        layer.mask = maskLayer
    }

//    MARK: - UIView

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}
