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
    optional func shotDetailsHeaderViewDidTapLikeButton(like: Bool, completion: (operationSucceed: Bool) -> Void)
}

class ShotDetailsHeaderView: UICollectionReusableView {
    
    // Public
    struct ViewData {
        let description: NSMutableAttributedString?
        let title: String
        let author: String
        let client: String
        let shotInfo: String
        let shot: String
        let avatar: String
        let shotLiked: Bool
    }
    
    var viewData: ViewData? {
        didSet {
            
            shotDescriptionView.descriptionText = viewData?.description ?? NSMutableAttributedString(string: "There is no decription")
            shotImageView.updateWith((viewData?.shot)!, byRoundingCorners: [.TopLeft, .TopRight], radius: CGFloat(imageViewCornerRadius))
            authorDetailsView.viewData = AuthorDetailsView.ViewData(avatar: (viewData?.avatar)!,
                title: (viewData?.title)!,
                author: (viewData?.author)!,
                client: (viewData?.client)!,
                shotInfo: (viewData?.shotInfo)!
            )
            shotDetailsOperationView.shotLiked = viewData?.shotLiked
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
    private let authorDetailsViewNormalHeight = CGFloat(100)
    private let authorDetailsViewCompactHeight = CGFloat(70)
    private let shotDetailsOperationViewHeight = CGFloat(40)
    
    
    // Colors
    private let headerBackgroundColor = UIColor(red:0.964, green:0.972, blue:0.972, alpha:1)
    
    // Private UI Components
    private let shotImageView = RoundedImageView(forAutoLayout: ())
    private let authorDetailsView = AuthorDetailsView.newAutoLayoutView()
    private let closeButton = UIButton(type: .System)
    private var shotDescriptionView = ShotDescriptionView.newAutoLayoutView()//UILabel(forAutoLayout: ())
    private let shotDetailsOperationView = ShotDetailsOperationView.newAutoLayoutView()
    
    // Constraints
    private var shotImageHeightConstraint: NSLayoutConstraint?
    private var authorDetailsViewHeightConstaint: NSLayoutConstraint?
    private var authorDetailsTopToShotImageBottom: NSLayoutConstraint?
    private var authorDetailsTopToSuperviewEdge: NSLayoutConstraint?
    private var shotOperationToAuthorDetailsBottom: NSLayoutConstraint?
    private var shotDescriptionTopToShotOperationDetailsBottom: NSLayoutConstraint?
    private var shotDescriptionToSuperviewEdge: NSLayoutConstraint?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        setupSubviews()
    }
    
    convenience init(viewData: ViewData) {
        self.init()
        
        backgroundColor = UIColor.clearColor()
        
        self.viewData = viewData
        
        setupSubviews()
        setupButtonsInteractions()
        
    }

    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func updateLikeButton(shotLiked shotLiked: Bool) {
        shotDetailsOperationView.updateLikeButton(liked: shotLiked)
    }
    
    func displayCompactVariant() {
        animateLayoutWithRegularAnimation()
    }

    func displayNormalVariant() {
        displayCompactVariant()
    }
    
    // MARK: UI
    
    override func intrinsicContentSize() -> CGSize {
        if shouldDisplayCompactVariant {
            return CGSize(width: UIScreen.mainScreen().bounds.width, height: topInset + shotImageCompactHeight)
        } else {
            // NGRFix: `shotDescriptionView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height` is improperly calculated
            return CGSize(width: UIScreen.mainScreen().bounds.width, height: topInset + shotDetailsOperationViewHeight + shotImageNormalHeight + authorDetailsViewNormalHeight + shotDescriptionView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height)
        }
    }
    
    class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        let leftAndRightMargin = CGFloat(10)
        let closeButtonRightMargin = CGFloat(-5)
        let closeButtonTopMargin = CGFloat(5)
        
        
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
            authorDetailsViewHeightConstaint = authorDetailsView.autoSetDimension(.Height, toSize: authorDetailsViewNormalHeight)
            
            shotOperationToAuthorDetailsBottom = shotDetailsOperationView.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorDetailsView)
            shotDetailsOperationView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            shotDetailsOperationView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            shotDetailsOperationView.autoSetDimension(.Height, toSize: shotDetailsOperationViewHeight)
            
            shotDescriptionTopToShotOperationDetailsBottom = shotDescriptionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotDetailsOperationView)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Bottom)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Left, withInset: leftAndRightMargin)
            shotDescriptionView.autoPinEdgeToSuperviewEdge(.Right, withInset: leftAndRightMargin)
            
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
                    self.shotImageView.updateFitting(.ScaleAspectFill)
                    self.shotImageView.useDimness(true)
                    
                    // AuthorDetails
                    self.authorDetailsTopToShotImageBottom?.autoRemove()
                    self.authorDetailsTopToSuperviewEdge = self.authorDetailsView.autoPinEdgeToSuperviewEdge(.Top, withInset: self.topInset)
                    self.shotDescriptionTopToShotOperationDetailsBottom?.autoRemove()
                    self.shotDescriptionToSuperviewEdge = self.shotDescriptionView.autoPinEdgeToSuperviewEdge(.Top)
                    
                    self.authorDetailsViewHeightConstaint?.constant = self.authorDetailsViewCompactHeight
                    self.authorDetailsView.displayAuthorDetailsInCompactSize()
                    
                    self.shotOperationToAuthorDetailsBottom?.autoRemove()
                    
                    UIView.animateWithDuration(self.animationDuration) {
                        self.authorDetailsView.backgroundColor = UIColor.clearColor()
                        self.authorDetailsView.hideShotInfoLabel()
                        self.authorDetailsView.setTextColor(UIColor.whiteColor())
                        self.shotDescriptionView.hidden = true
                        self.shotDetailsOperationView.hidden = true
                    }
                } else {
                    
                    // ShotImage
                    self.shotImageHeightConstraint?.constant = self.shotImageNormalHeight
                    self.shotImageView.updateFitting(.ScaleAspectFit)
                    self.shotImageView.useDimness(true)
                    
                    // AuthorDetails
                    self.authorDetailsTopToSuperviewEdge?.autoRemove()
                    self.authorDetailsTopToShotImageBottom?.autoInstall()
                    self.shotDescriptionToSuperviewEdge?.autoRemove()
                    self.shotDescriptionTopToShotOperationDetailsBottom?.autoInstall()

                    self.authorDetailsViewHeightConstaint?.constant = self.authorDetailsViewNormalHeight
                    self.authorDetailsView.displayAuthorDetailsInNormalSize()
                    
                    self.shotOperationToAuthorDetailsBottom?.autoInstall()
                    
                    UIView.animateWithDuration(self.animationDuration) {
                        self.authorDetailsView.setDefaultTextColor()
                        self.authorDetailsView.setDefaultBackgrounColor()
                        self.authorDetailsView.showShotInfoLabel()
                        self.shotDescriptionView.hidden = false
                        self.shotDetailsOperationView.hidden = false
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
        setupShotDetailsOperationView()
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
        addSubview(shotDescriptionView)
    }
    
    private func setupShotDetailsOperationView() {
        addSubview(shotDetailsOperationView)
    }
    
    private func setupButtonsInteractions() {
        authorDetailsView.authorButton.addTarget(self, action: "authorButtonDidTap:", forControlEvents: .TouchUpInside)
        authorDetailsView.clientButton.addTarget(self, action: "clientButtonDidTap:", forControlEvents: .TouchUpInside)
        shotDetailsOperationView.likeButton.addTarget(self, action: "likeButtonDidTap:", forControlEvents: .TouchUpInside)
    }
}

// MARK: UI Interactions

extension ShotDetailsHeaderView {
    dynamic private func closeButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsHeaderView(self, didTapCloseButton: sender)
    }
    
    dynamic private func authorButtonDidTap(_: UIButton) {
        // NGRTodo: consider replacing it with authorID
        let authorLink = viewData?.author ?? ""
        delegate?.shotDetailsHeaderView?(self, didTapAuthor: authorLink)
    }
    
    dynamic private func clientButtonDidTap(_: UIButton) {
        // NGRTodo: consider replacing it with clientID
        let clientLink = viewData?.client ?? ""
        delegate?.shotDetailsHeaderView?(self, didTapClient: clientLink)
    }
    
    // NGRTemp:
    dynamic private func likeButtonDidTap(_: UIButton) {
        delegate?.shotDetailsHeaderViewDidTapLikeButton?(!shotDetailsOperationView.shotLiked!){ operationSucceed -> Void in
            if operationSucceed {
                self.shotDetailsOperationView.updateLikeButton(liked: !self.shotDetailsOperationView.shotLiked!)
            }
        }
    }
}

// MARK: Reusable

extension ShotDetailsHeaderView: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsHeaderView)
    }
}
