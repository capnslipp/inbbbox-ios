//
//  CommentEditView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 15/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CommentEditView: UIView {

    // Private Properties
    private var didUpdateConstraints = false
    private let topInset = CGFloat(10)
    private let bottomInset = CGFloat(10)
    private let buttonSize = CGFloat(24)

    // Colors
    private let viewBackgroundColor = UIColor.clearColor()

    // public UI Components
    let cancelButton = UIButton()
    let cancelLabel = UILabel()
    let deleteButton = UIButton()
    let deleteLabel = UILabel()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = viewBackgroundColor
        setupSubviews()
    }

    @available(*, unavailable, message="Use init(frame: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {

        let distanceBetweenButtons = CGFloat(60)
        let buttonsCenterOffset = CGFloat(-5)
        let buttonsToLabelsAdditionalOffset = CGFloat(10)

        if !didUpdateConstraints {

            blurView.autoPinEdgesToSuperviewEdges()

            deleteButton.autoAlignAxis(.Horizontal, toSameAxisOfView: deleteButton.superview!, withOffset: buttonsCenterOffset)
            deleteButton.autoAlignAxis(.Vertical, toSameAxisOfView: deleteButton.superview!, withOffset: -(distanceBetweenButtons/2 + buttonSize/2))
            deleteButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))

            deleteLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: deleteButton, withOffset: buttonSize/2 + buttonsToLabelsAdditionalOffset)
            deleteLabel.autoAlignAxis(.Vertical, toSameAxisOfView: deleteButton)

            cancelButton.autoAlignAxis(.Horizontal, toSameAxisOfView: deleteButton)
            cancelButton.autoAlignAxis(.Vertical, toSameAxisOfView: cancelButton.superview!, withOffset: distanceBetweenButtons/2 + buttonSize/2)
            cancelButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))

            cancelLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: deleteLabel)
            cancelLabel.autoAlignAxis(.Vertical, toSameAxisOfView: cancelButton)

            didUpdateConstraints = true
        }

        super.updateConstraints()
    }

    // MARK: Private

    private func setupSubviews() {
        setupBlurView()
        setupCancelButton()
        setupDeleteButton()
        setupCancelLabel()
        setupDeleteLabel()
    }

    private func setupBlurView() {

        addSubview(blurView)
    }

    private func setupCancelButton() {
        cancelButton.setImage(UIImage(named: "bt-cancel-comment"), forState: .Normal)
        cancelButton.contentMode = .ScaleAspectFit
        blurView.addSubview(cancelButton)
    }

    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(named: "bt-delete-comment"), forState: .Normal)
        deleteButton.contentMode = .ScaleAspectFit
        blurView.addSubview(deleteButton)
    }

    private func setupCancelLabel() {
        cancelLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        cancelLabel.textColor = UIColor.textLightColor()
        cancelLabel.text = NSLocalizedString("CommentEditView.Cancel", comment: "Cancel editing comment.")
        blurView.addSubview(cancelLabel)
    }

    private func setupDeleteLabel() {
        deleteLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        deleteLabel.textColor = UIColor.textLightColor()
        deleteLabel.text = NSLocalizedString("CommentEditView.Delete", comment: "Editing comment, delete.")
        blurView.addSubview(deleteLabel)
    }
}
