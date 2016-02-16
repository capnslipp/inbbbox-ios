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
    private let buttonSize = CGFloat(30)
    
    // Colors
    private let viewBackgroundColor = UIColor.RGBA(0, 0, 0, 0.9)
    
    // public UI Components
    let cancelButton = UIButton()
    let deleteButton = UIButton()
    
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
    
    // MARK: Public
    
    // MARK: UI
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        let leftAndRightInset = CGFloat(50)
        
        if !didUpdateConstraints {
            
            deleteButton.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            deleteButton.autoPinEdgeToSuperviewEdge(.Leading, withInset: leftAndRightInset)
            deleteButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: bottomInset)
            deleteButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))
            
            cancelButton.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            cancelButton.autoPinEdgeToSuperviewEdge(.Trailing, withInset: leftAndRightInset)
            cancelButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: bottomInset)
            cancelButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupCancelButton()
        setupDeleteButton()
    }
    
    private func setupCancelButton() {
        cancelButton.setBackgroundImage(UIImage(named: "ic-likes-active"), forState: .Normal)
        addSubview(cancelButton)
    }
    
    private func setupDeleteButton() {
        deleteButton.setBackgroundImage(UIImage(named: "ic-likes"), forState: .Normal)
        addSubview(deleteButton)
    }
    
}
