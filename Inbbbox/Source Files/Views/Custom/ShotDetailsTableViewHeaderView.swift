//
//  ShotDetailsTableViewHeader.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol ShotDetailsTableViewHeaderViewDelegate: class {
    func shotDetailsHeaderView(view: ShotDetailsTableViewHeaderView, didTapCloseButton: UIButton)
}

class ShotDetailsTableViewHeaderView: UIView {
    
    weak var delegate: ShotDetailsTableViewHeaderViewDelegate?
    private var didUpdateConstraints = false
    private var shotImageView: RoundedImageView
    private var closeButton: UIButton
    private let imageViewCornerRadius = 15
    
    // MARK: Life Cycle
    
    init(withImage: UIImage) {
        shotImageView = RoundedImageView(
            withImage: withImage,
            byRoundingCorners: [.TopLeft, .TopRight],
            radius: CGSize(width: imageViewCornerRadius,
                height: imageViewCornerRadius),
            frame: CGRectZero)
        closeButton = UIButton(type: .System)
        
        super.init(frame: CGRectZero)
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
            shotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
            
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -14.6)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 5)
        
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupShotImageView()
        setupCloseButton()
    }
    
    private func setupShotImageView() {
        shotImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shotImageView)
    }
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(named: "ic-closemodal"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(closeButton)
    }
}

// MARK: UI Interactions

extension ShotDetailsTableViewHeaderView {
    @objc private func closeButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsHeaderView(self, didTapCloseButton: sender)
    }
}
