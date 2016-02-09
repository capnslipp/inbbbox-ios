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
            shotInfoLabel.text = viewData?.shotInfo
        }
    }
    
    let authorButton = UIButton.newAutoLayoutView()
    let clientButton = UIButton.newAutoLayoutView()
    
    // Private Properties
    private let avatarNormalSize = 48
    private let avatarCompactSize = 24
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
    private let linkColor = UIColor(red:0.941, green:0.215, blue:0.494, alpha:1)
    private let defaultTextColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
    
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
    
    func setText(color color: UIColor) {
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
    
    // MARK: UI
    
    override func updateConstraints() {
        
        let avatarViewNormalHeight: CGFloat = 22
        let avatarViewLeftInset: CGFloat = 20
        let titleLabelNormalHeight = avatarViewLeftInset
        let avatarToTextDetailsDistance: CGFloat = 15
        let spacingBetweenLabelsAndButtons: CGFloat = 2
        let tightenLettersInVerticalAxis: CGFloat = -5
        
        if !didUpdateConstraints {
            
            avatarView.autoSetDimensionsToSize(CGSize(width: avatarNormalSize, height: avatarNormalSize))
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: avatarViewLeftInset)
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: avatarViewNormalHeight)
            
            titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: titleLabelNormalHeight)
            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: avatarToTextDetailsDistance)
            
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
        shotInfoLabel.textColor = UIColor(red:0.427, green:0.427, blue:0.447, alpha:1)
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
        let avatar: UIImage
        let title: String
        let author: String
        let client: String
        let shotInfo: String
    }
}