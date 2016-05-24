//
//  CloseButtonView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 16/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CloseButtonView: UIView {

    let closeButton = UIButton(type: .System)
    let vibrancyView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    let dimView = UIView.newAutoLayoutView()

    private let diameterSize = CGFloat(26)
    private var didSetConstraints = false

    // MARK: - Life cycle

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        vibrancyView.layer.cornerRadius = diameterSize/2
        vibrancyView.clipsToBounds = true
        addSubview(vibrancyView)

        dimView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        vibrancyView.addSubview(dimView)

        closeButton.configureForAutoLayout()
        closeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.01)
        let image = UIImage(named: "ic-cross-naked")?.imageWithRenderingMode(.AlwaysOriginal)
        closeButton.setImage(image, forState: .Normal)
        addSubview(closeButton)
    }

    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            closeButton.autoPinEdgesToSuperviewEdges()
            dimView.autoPinEdgesToSuperviewEdges()
            vibrancyView.autoCenterInSuperview()
            vibrancyView.autoSetDimensionsToSize(CGSizeMake(diameterSize, diameterSize))
            autoSetDimensionsToSize(CGSize(width: diameterSize*1.2, height: diameterSize*1.2))
        }
        super.updateConstraints()
    }
}
