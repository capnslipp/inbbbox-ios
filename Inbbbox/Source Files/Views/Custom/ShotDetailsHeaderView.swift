//
//  ShotDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ShotDetailsTableViewHeaderViewDelegate: class {
    func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapCloseButton: UIButton)
    optional func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapAuthor: String)
    optional func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapClient: String)
}

class ShotDetailsHeaderView: UIView {
    
    struct ViewData {
        let description: String
        let title: String
        let author: String
        let client: String
        let shotInfo: String
        let shot: UIImage
        let avatar: UIImage
    }
    
    // Public
    var viewData: ViewData? {
        didSet {
            shotDescriptionView.text = viewData?.description
            titleLabel.text = viewData?.title
            authorButton.setTitle(viewData?.author, forState: .Normal)
            clientButton.setTitle(viewData?.client, forState: .Normal)
            shotInfoLabel.text = viewData?.shotInfo
            shotImageView.updateWith((viewData?.shot)!, byRoundingCorners: [.TopLeft, .TopRight], radius: CGFloat(imageViewCornerRadius), frame: CGRectZero)
            avatarView.updateWith((viewData?.avatar)!, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: CGFloat(avatarSize / 2), frame: CGRectZero)
        }
    }
    
    weak var delegate: ShotDetailsTableViewHeaderViewDelegate?
    
    // Private Properties
    private var didUpdateConstraints = false
    private let imageViewCornerRadius = 15
    private var shouldDisplayCompactVariant = false
    private let animationDuration: NSTimeInterval = 0.4
    private let avatarSize = 48
    
    // Colors & Fonts
    private let headerBackgroundColor = UIColor(red:0.964, green:0.972, blue:0.972, alpha:1)
    private let linkColor = UIColor(red:0.941, green:0.215, blue:0.494, alpha:1)
    private let detailsFont = UIFont.helveticaFont(.Neue, size: 13)
    
    // Private UI Components
    private let shotImageView = RoundedImageView(forAutoLayout: ())
    private let avatarView = RoundedImageView(forAutoLayout: ())
    private let closeButton = UIButton(type: .System)
    private let titleLabel = UILabel(forAutoLayout: ())
    private let authorPrefixLabel = UILabel(forAutoLayout: ())
    private let authorButton = UIButton(forAutoLayout: ())
    private let clientPrefixLabel = UILabel(forAutoLayout: ())
    private let clientButton = UIButton(forAutoLayout: ())
    private var shotInfoLabel = UILabel(forAutoLayout: ())
    private let shotDescriptionView = UITextView(forAutoLayout: ())
    
    // Constraints
    private var groupInfoTopConstraint: NSLayoutConstraint?
    private var shotImageTopConstraint: NSLayoutConstraint?
    private var avatarViewTopConstraint: NSLayoutConstraint?
    private var titleLabelTopConstraint: NSLayoutConstraint?
    private var authorPrefixLabelTopConstraint: NSLayoutConstraint?
    private var authorButtonTopConstraint: NSLayoutConstraint?
    private var clientPrefixTopConstraint: NSLayoutConstraint?
    private var clientButtonTopConstraint: NSLayoutConstraint?
    private var shotInfoLabelTopConstraint: NSLayoutConstraint?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = headerBackgroundColor
        setupSubviews()
    }

    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func displayCompactVariant() {
        animateLayoutWithRegularAnimation()
    }

    func displayNormalVariant() {
        displayCompactVariant()
    }
    
    // MARK: UI
    
    class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        let shotImageCompactHeight: CGFloat = 100
        let shotImageNormalHeight: CGFloat = 267
        
        let avatarViewAndTitleLabelCompactHeight: CGFloat = 25
        let avatarViewNormalHeight: CGFloat = 299
        let titleLabelNormalHeight: CGFloat = 297
        
        let authorAndClientCompactHeight: CGFloat = avatarViewAndTitleLabelCompactHeight + 20
        let authorAndClientNormalHeight: CGFloat = 319
        let spacingBetweenLabelsAndButtons: CGFloat = 2
        
        let shotInfoLabelNormalHeight: CGFloat = 348
        let shotInfoLabelCompactHeight: CGFloat = authorAndClientCompactHeight + 30
        
        if !didUpdateConstraints {
            
            shotImageView.autoPinEdgeToSuperviewEdge(.Top)
            shotImageTopConstraint = shotImageView.autoSetDimension(.Height, toSize: 267)
            
            closeButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 5)
            
            avatarView.autoSetDimensionsToSize(CGSize(width: avatarSize, height: avatarSize))
            avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: 20)
            avatarViewTopConstraint = avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: avatarViewNormalHeight)
            let avatarToTextDetailsDistance: CGFloat = 15
            
            titleLabelTopConstraint = titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: titleLabelNormalHeight)
            authorPrefixLabelTopConstraint = authorPrefixLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: authorAndClientNormalHeight)
            shotInfoLabelTopConstraint = shotInfoLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: shotInfoLabelNormalHeight)
            
            // Pin views in array to avatarView
            let views = [titleLabel, authorPrefixLabel, shotInfoLabel]
            for view in views {
                view.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: avatarToTextDetailsDistance)
            }

            authorButton.autoPinEdge(.Left, toEdge: .Right, ofView: authorPrefixLabel, withOffset: spacingBetweenLabelsAndButtons)
            authorButtonTopConstraint = authorButton.autoPinEdgeToSuperviewEdge(.Top, withInset: authorAndClientNormalHeight)
            authorButton.autoMatchDimension(.Height, toDimension: .Height, ofView: authorPrefixLabel)
            
            clientPrefixLabel.autoPinEdge(.Left, toEdge: .Right, ofView: authorButton, withOffset: spacingBetweenLabelsAndButtons)
            clientPrefixTopConstraint = clientPrefixLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: authorAndClientNormalHeight)
            
            clientButton.autoPinEdge(.Left, toEdge: .Right, ofView: clientPrefixLabel, withOffset: spacingBetweenLabelsAndButtons)
            clientButtonTopConstraint = clientButton.autoPinEdgeToSuperviewEdge(.Top, withInset: authorAndClientNormalHeight)
            clientButton.autoMatchDimension(.Height, toDimension: .Height, ofView: clientPrefixLabel)

            shotDescriptionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: avatarView, withOffset: 28)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Left)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Right)
            shotDescriptionView.sizeToFit()
            
            let leftAndRightMargin: CGFloat = 10
            shotImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            shotImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            
            didUpdateConstraints = true
        }
        
        // Animations
        let groupConstraintsOfAuthorAndClient = [authorPrefixLabelTopConstraint,
            authorButtonTopConstraint,
            clientPrefixTopConstraint,
            clientButtonTopConstraint,
            shotInfoLabelTopConstraint
        ]
        
        if shouldDisplayCompactVariant == true {
            shotImageTopConstraint?.constant = shotImageCompactHeight
            avatarViewTopConstraint?.constant = avatarViewAndTitleLabelCompactHeight
            titleLabelTopConstraint?.constant = avatarViewAndTitleLabelCompactHeight
            
            for constraint in groupConstraintsOfAuthorAndClient {
                constraint?.constant = authorAndClientCompactHeight
            }
            
            shotInfoLabelTopConstraint?.constant = shotInfoLabelCompactHeight
            shotDescriptionView.alpha = 0
        }
        else {
            shotImageTopConstraint?.constant = shotImageNormalHeight
            avatarViewTopConstraint?.constant = avatarViewNormalHeight
            titleLabelTopConstraint?.constant = titleLabelNormalHeight
            
            for constraint in groupConstraintsOfAuthorAndClient {
                constraint?.constant = authorAndClientNormalHeight
            }
            
            shotInfoLabelTopConstraint?.constant = shotInfoLabelNormalHeight
            shotDescriptionView.alpha = 1.0
        }
        
        super.updateConstraints()
    }

    // MARK: Private
    
    private func animateLayoutWithRegularAnimation() {
        
        self.shouldDisplayCompactVariant = !self.shouldDisplayCompactVariant
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(),
            animations: { () -> Void in
            self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func setupSubviews() {
        setupShotImageView()
        setupCloseButton()
        setupAvatarView()
        setupTitleLabel()
        setupPrefixAndAuthor()
        setupPrefixAndClient()
        setupShotInfoLabel()
        setupShotDescriptionView()
    }
    
    private func setupAvatarView() {
        avatarView.configureForAutoLayout()
        addSubview(avatarView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.helveticaFont(.NeueMedium, size: 17)
        titleLabel.textColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        addSubview(titleLabel)
    }
    
    private func setupShotImageView() {
        shotImageView.configureForAutoLayout()
        addSubview(shotImageView)
    }
    
    private func setupCloseButton() {
        closeButton.configureForAutoLayout()
        closeButton.setImage(UIImage(named: "ic-closemodal"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(closeButton)
    }
    
    private func setupPrefixAndAuthor() {
        let prefix = "by"
        authorPrefixLabel.text = prefix
        authorPrefixLabel.font = detailsFont
        addSubview(authorPrefixLabel)
        
        authorButton.titleLabel?.font = detailsFont
        authorButton.setTitleColor(linkColor, forState: .Normal)
        authorButton.addTarget(self, action: "authorButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(authorButton)
    }
    
    private func setupPrefixAndClient() {
        let prefix = "for"
        clientPrefixLabel.text = prefix
        clientPrefixLabel.font = detailsFont
        addSubview(clientPrefixLabel)
        
        clientButton.titleLabel?.font = detailsFont
        clientButton.setTitleColor(linkColor, forState: .Normal)
        clientButton.addTarget(self, action: "clientButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(clientButton)
    }
    
    private func setupShotInfoLabel() {
        shotInfoLabel.font = detailsFont
        shotInfoLabel.textColor = UIColor(red:0.427, green:0.427, blue:0.447, alpha:1)
        addSubview(shotInfoLabel)
    }
    
    private func setupShotDescriptionView() {
        shotDescriptionView.font = UIFont.helveticaFont(.Neue, size: 15)
        shotDescriptionView.textColor = UIColor(red: 0.3522, green: 0.3513, blue: 0.3722, alpha: 1.0 )
        shotDescriptionView.backgroundColor = UIColor(red: 0.9999, green: 1.0, blue: 0.9998, alpha: 1.0 )
        shotDescriptionView.scrollEnabled = false
        shotDescriptionView.editable = false
        shotDescriptionView.selectable = false
        shotDescriptionView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        addSubview(shotDescriptionView)
    }
}

// MARK: UI Interactions

extension ShotDetailsHeaderView {
    @objc private func closeButtonDidTap(sender: UIButton) {
         delegate?.shotDetailsHeaderView(self, didTapCloseButton: sender)
    }
    
    @objc private func authorButtonDidTap(sender: UIButton) {
        // NGRTodo: consider replacing it with authorID
        let authorLink = viewData?.author ?? ""
        delegate?.shotDetailsHeaderView?(self, didTapAuthor: authorLink)
    }
    
    @objc private func clientButtonDidTap(sender: UIButton) {
        // NGRTodo: consider replacing it with clientID
        let clientLink = viewData?.client ?? ""
        delegate?.shotDetailsHeaderView?(self, didTapAuthor: clientLink)
    }
}
