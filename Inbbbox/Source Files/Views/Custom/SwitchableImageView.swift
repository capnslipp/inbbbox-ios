//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DoubleImageView: UIView {

//    MARK: - Life cycle

    let firstImageView = UIImageView.newAutoLayoutView()
    let secondImageView = UIImageView.newAutoLayoutView()
    private var didSetupConstraints = false

    convenience init(firstImage: UIImage?, secondImage: UIImage?) {
        self.init(frame: CGRectZero)
        firstImageView.image = firstImage
        secondImageView.image = secondImage
        secondImageView.alpha = 0
        addSubview(firstImageView)
        addSubview(secondImageView)
    }


//    MARK: - Interface

    func displayFirstImageView() {
        firstImageView.alpha = 1
        secondImageView.alpha = 0
    }

    func displaySecondImageView() {
        firstImageView.alpha = 0
        secondImageView.alpha = 1
    }

//     MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        if !didSetupConstraints {
            firstImageView.autoPinEdgesToSuperviewEdges()
            secondImageView.autoPinEdgesToSuperviewEdges()
            didSetupConstraints = true
        }

        super.updateConstraints()
    }

    override func intrinsicContentSize() -> CGSize {
        let width = max(firstImageView.intrinsicContentSize().width, secondImageView.intrinsicContentSize().width)
        let height = max(firstImageView.intrinsicContentSize().height, secondImageView.intrinsicContentSize().height)
        return CGSize(width: width, height: height)
    }
}
