//
//  KeyboardResizableView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum KeyboardState {
    case WillAppear, WillDisappear, DidAppear, DidDisappear
}

protocol KeyboardResizableViewDelegate: class {

     /**
     Invokes when *KeyboardResizableView* is going to relayout itself (when keyboard will (dis)appear).

     - parameter view:  KeyboardResizableView instance.
     - parameter state: Indicates state of keyboard.
     */
    func keyboardResizableView(view: KeyboardResizableView, willRelayoutSubviewsWithState state: KeyboardState)

    /**
     Invokes when *KeyboardResizableView* did relayout itself (when keyboard did (dis)appear).

     - parameter view:  KeyboardResizableView instance.
     - parameter state: Indicates state of keyboard.
     */
    func keyboardResizableView(view: KeyboardResizableView, didRelayoutSubviewsWithState state: KeyboardState)
}

class KeyboardResizableView: UIView {

    /**
     The KeyboardResizableView's delegate object
     */
    weak var delegate: KeyboardResizableViewDelegate?

    /**
     Indicates whether keyboard is present or not.
     */
    private(set) var isKeyboardPresent = false {
        willSet(newValue) {
            if !newValue { snapOffset = 0 }
        }
    }

    /**
     Indicates whether *KeyboardResizableView* should snap to top edge of keyboard. Default `false`

     **Important**: when true, will ignore value of `bottomEdgeOffset` and treats it as `0`.
     */
    var automaticallySnapToKeyboardTopEdge = false

    /**
     Offset from keyboards top edge to bottom edge of *KeyboardResizableView*. Default `0`.
     */
    var bottomEdgeOffset = CGFloat(0)

    // Private variables:
    private var initialBottomConstraintConstant = CGFloat(0)
    private var bottomConstraint: NSLayoutConstraint!
    private var snapOffset = CGFloat(0)

    init() {
        super.init(frame: CGRect.zero)

        clipsToBounds = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    @available(*, unavailable, message="Use init() instead")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable, message="Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setReferenceBottomConstraint(constraint: NSLayoutConstraint) {
        bottomConstraint = constraint
        initialBottomConstraintConstant = constraint.constant
    }
}

// MARK: Notifications

extension KeyboardResizableView {

    func keyboardWillAppear(notification: NSNotification) {
        if !isKeyboardPresent {
            relayoutViewWithParameters(notification.userInfo!, keyboardPresence: true)
        }
        isKeyboardPresent = true
    }

    func keyboardWillDisappear(notification: NSNotification) {
        if isKeyboardPresent {
            relayoutViewWithParameters(notification.userInfo!, keyboardPresence: false)
        }
        isKeyboardPresent = false
    }
}

// MARK: Private

private extension KeyboardResizableView {

    func calculateCorrectKeyboardRectWithParameters(parameters: NSDictionary) -> CGRect {

        let rawKeyboardRect = parameters[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRect.zero
        return superview?.window?.convertRect(rawKeyboardRect, toView: superview) ?? CGRect.zero
    }

    func relayoutViewWithParameters(parameters: NSDictionary, keyboardPresence: Bool) {

        let properlyRotatedCoords = calculateCorrectKeyboardRectWithParameters(parameters)

        let height = properlyRotatedCoords.size.height
        let animationDuration = parameters[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber

        if automaticallySnapToKeyboardTopEdge && !isKeyboardPresent {

            let rectInSuperviewCoordinateSpace = superview!.convertRect(bounds, toView: self)
            let keyboardTopEdgeAndSelfBottomEdgeOffsetY = CGRectGetHeight(superview!.frame) - CGRectGetHeight(rectInSuperviewCoordinateSpace) + CGRectGetMinY(rectInSuperviewCoordinateSpace)

            snapOffset = keyboardTopEdgeAndSelfBottomEdgeOffsetY
        }

        var addition = height - snapOffset

        if !automaticallySnapToKeyboardTopEdge {
            addition += bottomEdgeOffset
        }

        let constant = keyboardPresence ? initialBottomConstraintConstant - addition : bottomConstraint.constant + addition
        bottomConstraint.constant = constant

        delegate?.keyboardResizableView(self, willRelayoutSubviewsWithState: keyboardPresence ? .WillAppear : .WillDisappear)

        UIView.animateWithDuration(animationDuration.doubleValue, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.delegate?.keyboardResizableView(self, didRelayoutSubviewsWithState: keyboardPresence ? .DidAppear : .DidDisappear)
        }
    }
}
