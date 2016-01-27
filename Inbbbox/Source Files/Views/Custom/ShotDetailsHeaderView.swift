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
    private let shotImageView: RoundedImageView
    private let imageViewCornerRadius = 15
    private let closeButton = UIButton(type: .System)
    private let avatarView: RoundedImageView
    private let avatarSize = 48
    private let titleLabel = UILabel(forAutoLayout: ())

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
            shotImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10, bottom: 100, right: 10))
            
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -15.0)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 5)
            
            avatarView.autoSetDimensionsToSize(CGSize(width: avatarSize, height: avatarSize))
            avatarView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotImageView, withOffset: 22)
            avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: 20)
            
            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 15)
            titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            titleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotImageView, withOffset: 20)
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupShotImageView()
        setupCloseButton()
        setupAvatarView()
        // NGRTemp: pass proper data here
        setupTitleLabelWithTitle("Weather Calendar Application")
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
        addSubview(avatarView)
    }
    
    private func setupTitleLabelWithTitle(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.helveticaFont(.NeueMedium, size: 17)
        titleLabel.textColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        addSubview(titleLabel)
    }

}

// MARK: UI Interactions

extension ShotDetailsHeaderView {
    @objc private func closeButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsHeaderView(self, didTapCloseButton: sender)
    }
}
