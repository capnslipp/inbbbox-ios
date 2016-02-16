//
//  ShotDetailsCollectionViewCell.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 05.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDetailsCollectionViewCell: UICollectionViewCell {
    
    // Public
    struct ViewData {
        let avatar: String
        let author: String
        let comment: NSMutableAttributedString
        let time: String
    }
    
    var viewData: ViewData? {
        didSet {
            avatar.updateWith((viewData?.avatar)!, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: CGFloat(avatarSize))
            author.text = viewData?.author
            comment.text = viewData?.comment.string
            time.text = viewData?.time
            
            setNeedsLayout()
        }
    }
    
    // Private Properties
    private var didUpdateConstraints = false
    private let avatarSize = CGFloat(32)
    
    // Private UI Components
    private let avatar = RoundedImageView.newAutoLayoutView()
    private let author = UILabel.newAutoLayoutView()
    private let comment = UILabel.newAutoLayoutView()
    private let time = UILabel.newAutoLayoutView()
    private let separatorLine = UIView.newAutoLayoutView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        setupSubviews()
        setNeedsUpdateConstraints()
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            
            let topInset = CGFloat(10)
            let leftInset = CGFloat(20)
            let rightInset = CGFloat(31)
            let avatarToTextInset = CGFloat(15)
            let authorHeight = CGFloat(20)
            let authorToTextDistance = CGFloat(3)
            let textToDateDistance = CGFloat(2)
            let commentMinimumHeight = CGFloat(40)
            let timeToSeparatorDistance = CGFloat(10)
            let separatorLineHeight = CGFloat(1)
            let separatorLineRightInset = CGFloat(20)
            let separatorLineLeftInset = CGFloat(67)
            
            avatar.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            avatar.autoPinEdgeToSuperviewEdge(.Left, withInset: leftInset)
            avatar.autoSetDimensionsToSize(CGSize(width: avatarSize, height: avatarSize))
            
            author.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            author.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            author.autoPinEdgeToSuperviewEdge(.Right)
            author.autoSetDimension(.Height, toSize: authorHeight)
            
            comment.autoPinEdge(.Top, toEdge: .Bottom, ofView: author, withOffset: authorToTextDistance)
            comment.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            comment.autoPinEdgeToSuperviewEdge(.Right, withInset: rightInset)
            comment.autoSetDimension(.Height, toSize: commentMinimumHeight, relation: .GreaterThanOrEqual)
            
            time.autoPinEdge(.Top, toEdge: .Bottom, ofView: comment, withOffset: textToDateDistance)
            time.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            
            separatorLine.autoPinEdge(.Top, toEdge: .Bottom, ofView: time, withOffset: timeToSeparatorDistance)
            separatorLine.autoSetDimension(.Height, toSize: separatorLineHeight)
            separatorLine.autoPinEdgeToSuperviewEdge(.Left, withInset: separatorLineLeftInset)
            separatorLine.autoPinEdgeToSuperviewEdge(.Right, withInset: separatorLineRightInset)
            separatorLine.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
    
    // Private
    
    private func setupSubviews() {
        setupAvatar()
        setupAuthor()
        setupComment()
        setupTime()
        setupSeparatorLine()
    }
    
    private func setupAvatar() {
        contentView.addSubview(avatar)
    }
    
    private func setupAuthor() {
        author.font = UIFont.helveticaFont(.NeueMedium, size: 16)
        author.textColor = UIColor.textDarkColor()
        contentView.addSubview(author)
    }
    
    private func setupComment() {
        comment.font = UIFont.helveticaFont(.Neue, size: 15)
        comment.textColor = UIColor.textLightColor()
        comment.numberOfLines = 0
        comment.lineBreakMode = .ByWordWrapping
        contentView.addSubview(comment)
    }
    
    private func setupTime() {
        time.font = UIFont.helveticaFont(.Neue, size: 10)
        time.textColor = UIColor.RGBA(164, 180, 188, 1)
        contentView.addSubview(time)
    }
    
    private func setupSeparatorLine() {
        separatorLine.backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        contentView.addSubview(separatorLine)
    }
}

extension ShotDetailsCollectionViewCell: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsCollectionViewCell)
    }
}

