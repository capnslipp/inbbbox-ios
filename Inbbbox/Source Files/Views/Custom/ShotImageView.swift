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

    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    private var didSetupConstraints = false
    private let bluredImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .followeeShotGrayColor()
        contentMode = .ScaleAspectFit

        addSubview(activityIndicatorView)
        
        bluredImageView.backgroundColor = UIColor.clearColor()
        addSubview(bluredImageView)
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
            bluredImageView.autoPinEdgesToSuperviewEdges()
        }

        super.updateConstraints()
    }

    func loadShotImageFromURL(url: NSURL, blur: CGFloat = 0) {
        image = nil
        activityIndicatorView.startAnimating()
        
        loadImageFromURL(url) { [weak self] finished, error in
            self?.bluredImageView.hidden = (blur == 0)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let bluredImage = self?.image?.imageByBlurringImageWithBlur(blur)
                dispatch_async(dispatch_get_main_queue(), {
                    self?.bluredImageView.image = bluredImage
                    });
                });
            self?.activityIndicatorView.stopAnimating()
        }
    }
}
