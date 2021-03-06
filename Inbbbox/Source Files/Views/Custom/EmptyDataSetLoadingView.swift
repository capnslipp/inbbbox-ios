//
//  EmptyDataSetLoadingView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

class EmptyDataSetLoadingView: UIView {

    let ballView: BouncingView
    let label = UILabel()
    let animator = LoginViewAnimations()

    private var shouldAnimate = false
    private let animationDuration = NSTimeInterval(1)
    private let ballJumpHeight = 50

    override init(frame: CGRect) {
        var frame = frame
        frame = CGRect(
            x: CGRectGetMinX(frame),
            y: CGRectGetMinY(frame),
            width: 200,
            height: 200
        )
        ballView = BouncingView(frame: frame, jumpHeight: ballJumpHeight, jumpDuration: animationDuration)
        super.init(frame: frame)

        addSubview(ballView)

        label.text = NSLocalizedString("EmptyDataSetLoadingView.Loading", comment: "Loading view, when empty data")
        label.textColor = .cellBackgroundColor()
        label.font = UIFont.helveticaFont(.NeueMedium, size: 25)
        label.textAlignment = .Center
        label.alpha = 0.5
        addSubview(label)

    }
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {

        // made on Rects because of complex animation of jumping ball, same comment as in LoginView
        let labelSize = CGSize(width: frame.width, height: 30)
        label.frame = CGRect(
            x: CGRectGetMaxX(frame) / 2 - labelSize.width / 2,
            y: CGRectGetMaxY(frame) / 2,
            width: labelSize.width,
            height: labelSize.height
        )

        let size = ballView.imageView.image?.size ?? CGSize.zero
        ballView.frame = CGRect(
            x: CGRectGetMaxX(frame) / 2 - size.width / 2,
            y: CGRectGetMinY(label.frame) - size.height - CGFloat(ballJumpHeight),
            width: size.width,
            height: size.height
        )
    }

    func startAnimating() {
        shouldAnimate =  true
        ballView.startAnimating()
        blinkLoadingLabel()
    }

    func stopAnimating() {
        shouldAnimate = false
    }

    private func blinkLoadingLabel() {

        guard shouldAnimate else { return }

        Async.main(after: animationDuration) {
            self.blinkLoadingLabel()
        }

        UIView.animateWithDuration(animationDuration * 0.5, animations: {
            self.label.alpha = 1.0
        }, completion: { _ in
            UIView.animateWithDuration(self.animationDuration * 0.5) { self.label.alpha = 0.5 }
        })
    }
}
