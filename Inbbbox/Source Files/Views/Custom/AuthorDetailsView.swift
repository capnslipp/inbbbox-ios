//
//  AuthorDetailsView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 06.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AuthorDetailsView: UIView {
    
    // Public
    var viewData: ViewData? {
        didSet {
            avatarView.updateWith((viewData?.avatar)!, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: CGFloat(avatarNormalSize / 2))
            titleLabel.text = viewData?.title
            authorButton.setTitle(viewData?.author, forState: .Normal)
            clientButton.setTitle(viewData?.client, forState: .Normal)
            clientPrefixLabel.hidden = viewData?.client == nil
            shotInfoLabel.text = viewData?.shotInfo
        }
    }
    
    let authorButton = UIButton.newAutoLayoutView()
    let clientButton = UIButton.newAutoLayoutView()
    
    // Private Properties
    private let avatarNormalSize = CGFloat(48)
    private let avatarCompactSize = CGFloat(24)
    private let bottomButtonsSize = CGFloat(24)
    private var didUpdateConstraints = false
    private let defaultBackgroundColor = UIColor.RGBA(246, 248, 248, 1)
    private let labels: [UILabel]
    private let buttons: [UIButton]
    
    // Private UI Components
    private let avatarView = RoundedImageView.newAutoLayoutView()
    private let titleLabel = UILabel.newAutoLayoutView()
    private let authorPrefixLabel = UILabel.newAutoLayoutView()
    private let clientPrefixLabel = UILabel.newAutoLayoutView()
    private var shotInfoLabel = UILabel.newAutoLayoutView()
    
    // Colors & Fonts
    private let detailsFont = UIFont.helveticaFont(.Neue, size: 13)
    private let compactDetailsFont = UIFont.helveticaFont(.Neue, size: 12)
    private let linkColor = UIColor.pinkColor()
    private let defaultTextColor = UIColor.textDarkColor()
    
    // Contraints
    private var avatarSizeConstraints: [NSLayoutConstraint]?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        labels = [titleLabel, authorPrefixLabel, clientPrefixLabel, shotInfoLabel]
        buttons = [authorButton, clientButton]
        super.init(frame: frame)
        backgroundColor = defaultBackgroundColor
        setupSubviews()
    }
    
    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func setTextColor(color: UIColor) {
        setColorToLabels(color)
        setColorToButtons(color)
    }
    
    func setDefaultTextColor() {
        setColorToLabels(defaultTextColor)
        setColorToButtons(linkColor)
    }
    
    func hideShotInfoLabel() {
        shotInfoLabel.hidden = true
    }
    
    func showShotInfoLabel() {
        shotInfoLabel.hidden = false
    }
    
    func setDefaultBackgrounColor() {
        backgroundColor = defaultBackgroundColor
    }
    
    func displayAuthorDetailsInNormalSize() {
        titleLabel.font = UIFont.helveticaFont(.NeueMedium, size: 17)
        authorPrefixLabel.font = detailsFont
        avatarSizeConstraints?.forEach {
            $0.constant = self.avatarNormalSize
        }
        avatarView.updateRadius(CGFloat(avatarNormalSize / 2))
        layoutIfNeeded()
    }
    
    func displayAuthorDetailsInCompactSize() {
        titleLabel.font = UIFont.helveticaFont(.NeueMedium, size: 15)
        authorPrefixLabel.font = compactDetailsFont
        avatarSizeConstraints?.forEach {
            $0.constant = self.avatarCompactSize
        }
        avatarView.updateRadius(CGFloat(avatarCompactSize / 2))
        layoutIfNeeded()
    }
    
    // MARK: UI
    
    override func updateConstraints() {
        
        let avatarViewNormalHeight = CGFloat(22)
        let avatarViewLeftInset = CGFloat(20)
        let titleLabelNormalHeight = avatarViewLeftInset
        let avatarToTextDetailsDistance = CGFloat(15)
        let spacingBetweenLabelsAndButtons = CGFloat(2)
        let tightenLettersInVerticalAxis = CGFloat(-5)
        
        if !didUpdateConstraints {
            
            avatarSizeConstraints = avatarView.autoSetDimensionsToSize(CGSize(width: avatarNormalSize, height: avatarNormalSize))
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: avatarViewLeftInset)
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: avatarViewNormalHeight)
            
            titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: titleLabelNormalHeight)
            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: avatarToTextDetailsDistance)
            titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            
            authorPrefixLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: tightenLettersInVerticalAxis)
            authorPrefixLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: avatarToTextDetailsDistance)

            authorButton.autoPinEdge(.Left, toEdge: .Right, ofView: authorPrefixLabel, withOffset: spacingBetweenLabelsAndButtons)
            authorButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: tightenLettersInVerticalAxis)
            authorButton.autoMatchDimension(.Height, toDimension: .Height, ofView: authorPrefixLabel)
            
            clientPrefixLabel.autoPinEdge(.Left, toEdge: .Right, ofView: authorButton, withOffset: spacingBetweenLabelsAndButtons)
            clientPrefixLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: tightenLettersInVerticalAxis)
            
            clientButton.autoPinEdge(.Left, toEdge: .Right, ofView: clientPrefixLabel, withOffset: spacingBetweenLabelsAndButtons)
            clientButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: tightenLettersInVerticalAxis)
            clientButton.autoMatchDimension(.Height, toDimension: .Height, ofView: clientPrefixLabel)

            shotInfoLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorPrefixLabel, withOffset: tightenLettersInVerticalAxis)
            shotInfoLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: avatarToTextDetailsDistance)
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupAvatar()
        setupTitle()
        setupPrefixAndAuthor()
        setupPrefixAndClient()
        setupShotInfoLabel()
    }
    
    private func setupAvatar() {
        addSubview(avatarView)
    }
    
    private func setupTitle() {
        titleLabel.font = UIFont.helveticaFont(.NeueMedium, size: 17)
        titleLabel.minimumScaleFactor = 8/titleLabel.font.pointSize;
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true;
        titleLabel.textColor = defaultTextColor
        addSubview(titleLabel)
    }
    
    private func setupPrefixAndAuthor() {
        let prefix = NSLocalizedString("by", comment: "")
        authorPrefixLabel.text = prefix
        authorPrefixLabel.font = detailsFont
        addSubview(authorPrefixLabel)
        
        authorButton.titleLabel?.font = detailsFont
        authorButton.setTitleColor(linkColor, forState: .Normal)
        addSubview(authorButton)
    }
    
    private func setupPrefixAndClient() {
        let prefix = NSLocalizedString("for", comment: "")
        clientPrefixLabel.text = prefix
        clientPrefixLabel.font = detailsFont
        addSubview(clientPrefixLabel)
        
        clientButton.titleLabel?.font = detailsFont
        clientButton.setTitleColor(linkColor, forState: .Normal)
        addSubview(clientButton)
    }
    
    private func setupShotInfoLabel() {
        shotInfoLabel.font = detailsFont
        shotInfoLabel.textColor = UIColor.textLightColor()
        addSubview(shotInfoLabel)
    }
    
    private func setColorToLabels(color: UIColor) {
        for label in labels {
            label.textColor = color
        }
    }
    
    private func setColorToButtons(color: UIColor) {
        for button in buttons {
            button.titleLabel?.textColor = color
        }
    }
}

extension AuthorDetailsView {
    struct ViewData {
        let avatar: String
        let title: String
        let author: String
        let client: String?
        let shotInfo: String
    }
}
