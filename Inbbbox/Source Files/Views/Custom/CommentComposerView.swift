//
//  CommentComposerView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol CommentComposerViewDelegate {
    func commentComposerViewDidBecomeActive(view: CommentComposerView)
    func didTapSendButtonInComposerView(view: CommentComposerView, comment: String)
}

class CommentComposerView: UIView {
    
    var delegate: CommentComposerViewDelegate?
    
    private let cornerWrapperView = UIView.newAutoLayoutView()
    private let textField = UITextField.newAutoLayoutView()
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var didUpdateConstraints = false
    private var sendButton: UIButton? {
        return textField.rightView as? UIButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        
        cornerWrapperView.clipsToBounds = true
        cornerWrapperView.backgroundColor = .RGBA(246, 248, 248, 1)
        addSubview(cornerWrapperView)
        
        textField.backgroundColor = .RGBA(246, 248, 248, 1)
        textField.placeholder = NSLocalizedString("Type your comment", comment: "")
        textField.tintColor = UIColor(red: 0.3522, green: 0.3513, blue: 0.3722, alpha: 1.0)
        textField.setLeftPadding(10)
        textField.delegate = self
        textField.autocorrectionType = .No
        textField.rightViewMode = .Always
        textField.addTarget(self, action: "textFieldValueDidChange:", forControlEvents: .EditingChanged)
        textField.rightView = button
        cornerWrapperView.addSubview(textField)
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let inset = CGFloat(20)
            
            cornerWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            cornerWrapperView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: -inset)
            
            let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5 + inset, right: 5)
            textField.autoPinEdgesToSuperviewEdgesWithInsets(insets)
        }
        
        super.updateConstraints()
    }
}

extension CommentComposerView {
    
    func addCommentButtonDidTap(_: UIButton) {
        
        guard let text = textField.text where text.characters.count > 0 else {
            return
        }
        
        delegate?.didTapSendButtonInComposerView(self, comment: text)
        
        textField.text = nil
        sendButton?.enabled = false
    }
    
    func textFieldValueDidChange(textField: UITextField) {
        sendButton?.enabled = textField.text?.characters.count > 0
    }
    
    func startAnimation() {
        textField.enabled = false
        textField.rightView = activityIndicatorView
    }
    
    func stopAnimation() {
        textField.enabled = true
        textField.rightView = button
    }
    
    func makeActive() {
        textField.becomeFirstResponder()
    }
    
    func animateByRoundingCorners(round: Bool) {
        
        let from: CGFloat = round ? 0 : 10
        let to: CGFloat = round ? 10 : 0
        addCornerRadiusAnimation(from, to: to, duration: 0.3)
    }
}

extension CommentComposerView: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        sendButton?.enabled = false
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.commentComposerViewDidBecomeActive(self)
    }
}

private extension CommentComposerView {
    
    var button: UIButton {
        let button = UIButton(type: .Custom)
        button.enabled = false
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        button.setImage(UIImage(named: "ic-sendmessage"), forState: .Normal)
        button.addTarget(self, action: "addCommentButtonDidTap:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    var activityIndicatorView: UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        activityIndicatorView.color = .pinkColor()
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }
    
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        cornerWrapperView.layer.addAnimation(animation, forKey: "cornerRadius")
        cornerWrapperView.layer.cornerRadius = to
    }
}
