//
//  ShotImageView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 12/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout
import KFSwiftImageLoader
import Gifu

class ShotImageView: UIImageView {

    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var didSetupConstraints = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .followeeShotGrayColor()
        contentMode = .ScaleAspectFit

        activityIndicatorView.color = .whiteColor()
        addSubview(activityIndicatorView)
    }

    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        if !didSetupConstraints {
            didSetupConstraints = true

            activityIndicatorView.autoCenterInSuperview()
        }

        super.updateConstraints()
    }

    func loadShotImageFromURL(url: NSURL, blur: CGFloat = 0) {

        image = nil
        activityIndicatorView.startAnimating()
        
        loadImageFromURL(url) { [weak self] finished, error in
            self?.image = self?.image?.imageByBlurringImageWithBlur(blur)
            self?.activityIndicatorView.stopAnimating()
        }
    }
}
