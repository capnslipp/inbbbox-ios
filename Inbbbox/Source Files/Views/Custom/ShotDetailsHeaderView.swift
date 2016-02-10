//
//  ShotDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

@objc protocol ShotDetailsHeaderViewDelegate: class {
    func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapCloseButton: UIButton)
    optional func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapAuthor: String)
    optional func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapClient: String)
}

class ShotDetailsHeaderView: UICollectionReusableView {
    
    // Public
    struct ViewData {
        let description: String
        let title: String
        let author: String
        let client: String
        let shotInfo: String
        let shot: UIImage
        let avatar: UIImage
    }
    
    var viewData: ViewData? {
        didSet {
            shotDescriptionView.text = viewData?.description
            shotImageView.updateWith((viewData?.shot)!, byRoundingCorners: [.TopLeft, .TopRight], radius: CGFloat(imageViewCornerRadius))
            authorDetailsView.viewData = AuthorDetailsView.ViewData(avatar: (viewData?.avatar)!,
                title: (viewData?.title)!,
                author: (viewData?.author)!,
                client: (viewData?.client)!,
                shotInfo: (viewData?.shotInfo)!
            )
            setupButtonsInteractions()
        }
    }
    
    weak var delegate: ShotDetailsHeaderViewDelegate?
    
    // Private Properties
    private var didUpdateConstraints = false
    private let imageViewCornerRadius = 15
    private var shouldDisplayCompactVariant = false
    private let animationDuration: NSTimeInterval = 0.4
    
    // Contraints values
    private let topInset = CGFloat(30)
    private let shotImageNormalHeight = CGFloat(267)
    private let shotImageCompactHeight = CGFloat(70)
    
    // Colors
    private let headerBackgroundColor = UIColor(red:0.964, green:0.972, blue:0.972, alpha:1)
    
    // Private UI Components
    private let shotImageView = RoundedImageView(forAutoLayout: ())
    private let authorDetailsView = AuthorDetailsView.newAutoLayoutView()
    private let closeButton = UIButton(type: .System)
    private let shotDescriptionView = UITextView(forAutoLayout: ())
    
    // Constraints
    private var shotImageHeightConstraint: NSLayoutConstraint?
    private var authorDetailsTopToShotImageBottom: NSLayoutConstraint?
    private var authorDetailsTopToSuperviewEdge: NSLayoutConstraint?
    private var shotDescriptionTopToAuthorDetailsBottom: NSLayoutConstraint?
    private var shotDescriptionToSuperviewEdge: NSLayoutConstraint?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
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
    
    func requiredSize() -> CGSize {
        // NGRHack: value of `systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)` is improperly calculated in compact mode although all constraints seem to be ok.
        if shouldDisplayCompactVariant {
            return CGSize(width: UIScreen.mainScreen().bounds.width, height: topInset + shotImageCompactHeight)
        } else {
            return systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)
        }
    }
    
    // MARK: UI
    
    class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        let leftAndRightMargin = CGFloat(10)
        let closeButtonRightMargin = CGFloat(-5)
        let closeButtonTopMargin = CGFloat(5)
        let authorDetailsViewHeight = CGFloat(100)
        
        if !didUpdateConstraints {
            shotImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset).autoIdentify("[shotImageView] .Top = \(topInset)")
            shotImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            shotImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            shotImageHeightConstraint =  shotImageView.autoSetDimension(.Height, toSize: shotImageNormalHeight).autoIdentify("[shotImageView] .Height = \(shotImageNormalHeight)")
            
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: shotImageView, withOffset:closeButtonRightMargin)
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: shotImageView, withOffset: closeButtonTopMargin)
            
            authorDetailsTopToShotImageBottom = authorDetailsView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotImageView)
            authorDetailsView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            authorDetailsView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            authorDetailsView.autoSetDimension(.Height, toSize: authorDetailsViewHeight)
            
            shotDescriptionTopToAuthorDetailsBottom = shotDescriptionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorDetailsView)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Bottom)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.shotDescriptionView.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            didUpdateConstraints = true
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
                
                // Animations
                if self.shouldDisplayCompactVariant {
                    
                    // ShotImage
                    self.shotImageHeightConstraint?.constant = self.shotImageCompactHeight
                    
                    // AuthorDetails
                    self.authorDetailsTopToShotImageBottom?.autoRemove()
                    self.authorDetailsTopToSuperviewEdge = self.authorDetailsView.autoPinEdgeToSuperviewEdge(.Top, withInset: self.topInset)
                    self.shotDescriptionTopToAuthorDetailsBottom?.autoRemove()
                    self.shotDescriptionToSuperviewEdge = self.shotDescriptionView.autoPinEdgeToSuperviewEdge(.Top)
                    
                    self.authorDetailsView.displayAuthorDetailsInCompactSize()
                    
                    UIView.animateWithDuration(self.animationDuration) {
                        self.authorDetailsView.backgroundColor = UIColor.clearColor()
                        self.authorDetailsView.hideShotInfoLabel()
                        self.authorDetailsView.setTextColor(UIColor.whiteColor())
                        self.shotDescriptionView.hidden = true
                    }
                } else {
                    
                    // ShotImage
                    self.shotImageHeightConstraint?.constant = self.shotImageNormalHeight
                    
                    // AuthorDetails
                    self.authorDetailsTopToSuperviewEdge?.autoRemove()
                    self.authorDetailsTopToShotImageBottom?.autoInstall()
                    self.shotDescriptionToSuperviewEdge?.autoRemove()
                    self.shotDescriptionTopToAuthorDetailsBottom?.autoInstall()
                    
                    self.authorDetailsView.displayAuthorDetailsInNormalSize()
                    
                    UIView.animateWithDuration(self.animationDuration) {
                        self.authorDetailsView.setDefaultTextColor()
                        self.authorDetailsView.setDefaultBackgrounColor()
                        self.authorDetailsView.showShotInfoLabel()
                        self.shotDescriptionView.hidden = false
                    }
                }
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func setupSubviews() {
        setupShotImageView()
        setupAuthorDetailsView()
        setupCloseButton()
        setupShotDescriptionView()
    }
    
    private func setupAuthorDetailsView() {
        addSubview(authorDetailsView)
    }
    
    private func setupShotImageView() {
        shotImageView.contentMode = .ScaleAspectFit
        addSubview(shotImageView)
    }
    
    private func setupCloseButton() {
        closeButton.configureForAutoLayout()
        closeButton.setImage(UIImage(named: "ic-closemodal"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        addSubview(closeButton)
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
    
    private func setupButtonsInteractions() {
        authorDetailsView.authorButton.addTarget(self, action: "authorButtonDidTap:", forControlEvents: .TouchUpInside)
        authorDetailsView.clientButton.addTarget(self, action: "clientButtonDidTap:", forControlEvents: .TouchUpInside)
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

// MARK: Reusable

extension ShotDetailsHeaderView: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsHeaderView)
    }
}
