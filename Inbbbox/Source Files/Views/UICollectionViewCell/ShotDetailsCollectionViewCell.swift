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
        let avatar: UIImage
        let author: String
        let comment: String
        let time: String
    }
    
    var viewData: ViewData? {
        didSet {
            avatar.updateWith((viewData?.avatar)!, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: CGFloat(avatarSize))
            author.text = viewData?.author
            comment.text = viewData?.comment
            time.text = viewData?.time
        }
    }
    
    // Private Properties
    private var didUpdateConstraints = false
    private let avatarSize: CGFloat = 32
    
    // Private UI Components
    private let avatar = RoundedImageView.newAutoLayoutView()
    private let author = UILabel.newAutoLayoutView()
    private let comment = UILabel.newAutoLayoutView()
    private let time = UILabel.newAutoLayoutView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        setupSubviews()
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI
    override func updateConstraints() {
        if !didUpdateConstraints {
            
            let topInset: CGFloat = 10
            let leftInset: CGFloat = 20
            let rightInset: CGFloat = 31
            let avatarToTextInset: CGFloat = 15
            let authorHeight: CGFloat = 20
            
            avatar.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            avatar.autoPinEdgeToSuperviewEdge(.Left, withInset: leftInset)
            avatar.autoSetDimensionsToSize(CGSize(width: avatarSize, height: avatarSize))
            
            author.autoPinEdgeToSuperviewEdge(.Top, withInset: topInset)
            author.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            author.autoPinEdgeToSuperviewEdge(.Right)
            author.autoSetDimension(.Height, toSize: authorHeight)
            
            comment.autoPinEdge(.Top, toEdge: .Bottom, ofView: author)
            comment.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            comment.autoPinEdgeToSuperviewEdge(.Right, withInset: rightInset)
            
            time.autoPinEdge(.Top, toEdge: .Bottom, ofView: comment)
            time.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: avatarToTextInset)
            time.autoPinEdgeToSuperviewEdge(.Bottom)
            
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
    }
    
    private func setupAvatar() {
        contentView.addSubview(avatar)
    }
    
    private func setupAuthor() {
        author.font = UIFont.helveticaFont(.NeueMedium, size: 16)
        author.textColor = UIColor.RGBA(51, 51, 51, 1)
        contentView.addSubview(author)
    }
    
    private func setupComment() {
        comment.font = UIFont.helveticaFont(.Neue, size: 15)
        comment.textColor = UIColor.RGBA(113, 113, 117, 1)
        comment.numberOfLines = 0
        contentView.addSubview(comment)
    }
    
    private func setupTime() {
        time.font = UIFont.helveticaFont(.Neue, size: 10)
        time.textColor = UIColor.RGBA(164, 180, 188, 1)
        contentView.addSubview(time)
    }
}

extension ShotDetailsCollectionViewCell: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsCollectionViewCell)
    }
}

