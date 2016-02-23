//
//  CommentComposerView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol CommentComposerViewDelegate {
    func didTapSendButtonInComposerView(view: CommentComposerView, withComment: String?)
}

class CommentComposerView: UIView {
    
    var delegate: CommentComposerViewDelegate?
    
    private let textField = UITextField.newAutoLayoutView()
    private var didUpdateConstraints = false
    private var sendButton: UIButton? {
        return textField.rightView as? UIButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.backgroundGrayColor()
        
        textField.backgroundColor = UIColor.backgroundGrayColor()
        textField.placeholder = NSLocalizedString("Type your comment", comment: "")
        textField.tintColor = UIColor(red: 0.3522, green: 0.3513, blue: 0.3722, alpha: 1.0)
        textField.setLeftPadding(10)
        textField.delegate = self
        textField.rightViewMode = .Always
        textField.addTarget(self, action: "textFieldValueDidChange:", forControlEvents: .EditingChanged)
        textField.rightView = {
            let button = UIButton(type: .Custom)
            button.enabled = false
            button.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
            button.setImage(UIImage(named: "ic-sendmessage"), forState: .Normal)
            button.addTarget(self, action: "addCommentButtonDidTap:", forControlEvents: .TouchUpInside)
            
            return button
        }()
        addSubview(textField)
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    @available(*, unavailable, message="Use init(frame: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            textField.autoPinEdgesToSuperviewEdgesWithInsets(insets)
        }
        
        super.updateConstraints()
    }
}

extension CommentComposerView {
    
    func addCommentButtonDidTap(_: UIButton) {
        
        guard textField.text?.characters.count > 0 else {
            return
        }
        
        delegate?.didTapSendButtonInComposerView(self, withComment: textField.text)
        
        textField.text = nil
        sendButton?.enabled = false
    }
    
    func textFieldValueDidChange(textField: UITextField) {
        sendButton?.enabled = textField.text?.characters.count > 0
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
}
