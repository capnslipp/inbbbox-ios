//
//  ActivityIndicatorSelectableView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum ActivityIndicatorSelectableViewState {
    case Selected, Deselected
}

class ActivityIndicatorSelectableView: UIView {

    var selected: Bool {
        get { return button.selected }
        set { button.selected = newValue }
    }

    var tapHandler: (() -> Void)?

    private let bouncingBall: BouncingView
    private let button = UIButton(type: .Custom)

    private var didSetConstraints = false
    private var wasSelectedBeforeAnimationStart = false

    override init(frame: CGRect) {
        bouncingBall = BouncingView(frame: frame, jumpHeight: 20, jumpDuration: 0.8)
        bouncingBall.configureForAutoLayout()
        super.init(frame: frame)

        button.configureForAutoLayout()
        button.imageView?.backgroundColor = .clearColor()
        button.contentMode = .ScaleAspectFit
        button.setImage(UIImage(), forState: .Disabled)
        button.addTarget(self, action: #selector(buttonDidTap(_:)), forControlEvents: .TouchUpInside)
        addSubview(button)

        addSubview(bouncingBall)
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true

            button.autoPinEdgesToSuperviewEdges()
            bouncingBall.autoPinEdgesToSuperviewEdges()
        }
        super.updateConstraints()
    }

    func setImage(image: UIImage?, forState state: ActivityIndicatorSelectableViewState) {
        button.setImage(image, forState: state.controlState)
    }

    func startAnimating() {
        if !bouncingBall.shouldAnimate {
            bouncingBall.startAnimating()
        }
        button.hidden = true
    }

    func stopAnimating() {
        button.hidden = false
        bouncingBall.stopAnimating()
    }
}

private extension ActivityIndicatorSelectableView {

    dynamic func buttonDidTap(_: UIButton) {
        tapHandler?()
    }
}

private extension ActivityIndicatorSelectableViewState {

    var controlState: UIControlState {
        return self == .Selected ? .Selected : .Normal
    }
}
