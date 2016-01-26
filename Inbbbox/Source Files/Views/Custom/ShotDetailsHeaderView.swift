//
//  ShotDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol ShotDetailsTableViewHeaderViewDelegate: class {
    func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapCloseButton: UIButton)
}

class ShotDetailsHeaderView: UIView {
    
    weak var delegate: ShotDetailsTableViewHeaderViewDelegate?
    private var didUpdateConstraints = false
    private var shotImageView: RoundedImageView
    private let imageViewCornerRadius = 15
    private var closeButton: UIButton
    private var avatarView: RoundedImageView
    private let avatarSize = 48
    
    // MARK: Life Cycle
    
    /* NGRTemp: Replace with custom-object initialization 
        image, avatar, title, description, other data */
    init(image: UIImage) {
        shotImageView = RoundedImageView(
            image: image,
            byRoundingCorners: [.TopLeft, .TopRight],
            radius: CGFloat(imageViewCornerRadius),
            frame: CGRectZero
        )
        closeButton = UIButton(type: .System)
        
        avatarView = RoundedImageView(
            image: image,
            byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight],
            radius: CGFloat(avatarSize / 2),
            frame: CGRectZero
        )
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(red:0.964, green:0.972, blue:0.972, alpha:1)
        setupSubviews()
    }

    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    
    // MARK: UI
    
    class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            shotImageView.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: 10)
            shotImageView.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -10)
            shotImageView.autoPinEdge(.Top, toEdge: .Top, ofView: self)
            shotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: -100)
            
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -14.6)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 5)
            
            avatarView.autoSetDimensionsToSize(CGSize(width: avatarSize, height: avatarSize))
            avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: 20)
            avatarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: -40)
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupShotImageView()
        setupCloseButton()
        setupAvatarView()
    }
    
    private func setupShotImageView() {
        shotImageView.configureForAutoLayout()
        shotImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shotImageView)
    }
    
    private func setupCloseButton() {
        closeButton.configureForAutoLayout()
        closeButton.setImage(UIImage(named: "ic-closemodal"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(closeButton)
    }
    
    private func setupAvatarView() {
        avatarView.configureForAutoLayout()
        avatarView.backgroundColor = UIColor.yellowColor()
        addSubview(avatarView)
    }
}

// MARK: UI Interactions

extension ShotDetailsHeaderView {
    @objc private func closeButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsHeaderView(self, didTapCloseButton: sender)
    }
}
