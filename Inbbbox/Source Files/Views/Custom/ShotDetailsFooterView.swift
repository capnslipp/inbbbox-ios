//
//  ShotDetailsFooterView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 29.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol ShotDetailsFooterViewDelegate: class {
    func shotDetailsFooterView(view: ShotDetailsFooterView, didTapAddCommentButton: UIButton, forMessage message: String?)
}

class ShotDetailsFooterView: UICollectionReusableView {

    // Pubic
    let textField: UITextField
    weak var delegate: ShotDetailsFooterViewDelegate?
    
    // Private Properties
    private var didUpdateConstraints = false
    private let corners: UIRectCorner = [.BottomLeft, .BottomRight]
    private let normalRadius = CGFloat(15)
    private let editingRadius = CGFloat(0)
    private var shouldDisplayEditingVariant = false
    private let sideNormalMargin = CGFloat(10)
    private let sideEditingMargin = CGFloat(0)

    // Private UI Components
    private let roundedTextFieldView = RoundedTextField(forAutoLayout: ())
    
    // Constraints
    private var leftMarginTextFieldConstraint: NSLayoutConstraint?
    private var rightMarginTextFieldConstraint: NSLayoutConstraint?

    // MARK: Life Cycle

    override init(frame: CGRect) {
        textField = roundedTextFieldView.textField
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        setupSubviews()
    }

    @available(*, unavailable, message="Use init(frame: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func displayEditingVariant() {
        roundedTextFieldView.update(corners, radius: editingRadius)
        updateTextFieldLayout()
    }
    
    func displayNormalVariant() {
        roundedTextFieldView.update(corners, radius: normalRadius)
        updateTextFieldLayout()
    }

    // MARK: Auto Layout
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 61)
    }
    
    class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {
        
        if !didUpdateConstraints {
            roundedTextFieldView.autoPinEdgeToSuperviewEdge(.Top)
            roundedTextFieldView.autoPinEdgeToSuperviewEdge(.Bottom)
            leftMarginTextFieldConstraint = roundedTextFieldView.autoPinEdgeToSuperviewEdge(.Left, withInset: sideNormalMargin)
            rightMarginTextFieldConstraint = roundedTextFieldView.autoPinEdgeToSuperviewEdge(.Right, withInset: sideNormalMargin)

            didUpdateConstraints = true
        }
        
        if shouldDisplayEditingVariant == true {
            leftMarginTextFieldConstraint?.constant = sideEditingMargin
            rightMarginTextFieldConstraint?.constant = sideEditingMargin
        } else {
            leftMarginTextFieldConstraint?.constant = sideNormalMargin
            rightMarginTextFieldConstraint?.constant = -sideNormalMargin
        }

        super.updateConstraints()
    }

    // MARK: Private
    
    private func updateTextFieldLayout() {
        shouldDisplayEditingVariant = !shouldDisplayEditingVariant
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
    
    private func setupSubviews() {
        setupRoundedTextFieldView()
        setupTextField()
    }
    
    private func setupRoundedTextFieldView() {
        roundedTextFieldView.update(corners, radius: normalRadius)
        addSubview(roundedTextFieldView)
    }
    
    private func setupTextField() {
        textField.backgroundColor = UIColor(red: 0.9555, green: 0.9658, blue: 0.9654, alpha: 1.0)
        textField.placeholder = "Type your comment"
        textField.tintColor = UIColor(red: 0.3522, green: 0.3513, blue: 0.3722, alpha: 1.0)
        textField.setLeft(padding: 21)
        
        let addCommentButton = UIButton(type: .Custom)
        let widthAsRightButtonPadding = 65
        let buttonHeight = 40
        addCommentButton.frame = CGRect(x: 0, y: 0, width: widthAsRightButtonPadding, height: buttonHeight)
        addCommentButton.setImage(UIImage(named: "ic-sendmessage"), forState: .Normal)
        addCommentButton.addTarget(self, action: "addCommentButtonDidTap:", forControlEvents: .TouchUpInside)
        textField.rightView = addCommentButton
        textField.rightViewMode = .Always
    }
}

// MARK: UI Interactions

extension ShotDetailsFooterView {
    @objc private func addCommentButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsFooterView(self, didTapAddCommentButton: sender, forMessage: textField.text)
    }
}

// MARK: Reusable

extension ShotDetailsFooterView: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsFooterView)
    }
}
