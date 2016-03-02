//
//  ShotDetailsCommentCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

private var margin: CGFloat {
    return 5
}

class ShotDetailsCommentCollectionViewCell: UICollectionViewCell {
    
    var deleteActionHandler: (Void -> Void)?
    
    let avatarView = AvatarView(size: CGSize(width: 40, height: 40), bordered: false)
    let authorLabel = UILabel.newAutoLayoutView()
    let commentLabel = UILabel.newAutoLayoutView()
    let dateLabel = UILabel.newAutoLayoutView()
    private let editView = CommentEditView.newAutoLayoutView()
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showEditView(false)
        configureForAutoLayout()
        
        contentView.configureForAutoLayout()
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        
        avatarView.configureForAutoLayout()
        avatarView.imageView.image = UIImage(named: "avatar_placeholder")
        contentView.addSubview(avatarView)
        
        authorLabel.font = UIFont.helveticaFont(.NeueMedium, size: 16)
        authorLabel.numberOfLines = 0
        authorLabel.textColor = UIColor.textDarkColor()
        contentView.addSubview(authorLabel)

        commentLabel.font = UIFont.helveticaFont(.Neue, size: 15)
        commentLabel.textColor = UIColor.textLightColor()
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(commentLabel)
        
        dateLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        dateLabel.numberOfLines = 0
        dateLabel.textColor = UIColor.RGBA(164, 180, 188, 1)
        contentView.addSubview(dateLabel)
        
        editView.deleteButton.addTarget(self, action: "deleteButtonDidTap:", forControlEvents: .TouchUpInside)
        editView.cancelButton.addTarget(self, action: "cancelButtonDidTap:", forControlEvents: .TouchUpInside)
        contentView.addSubview(editView)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let preferredMaxLayoutWidth = frame.size.width - 3 * margin - avatarView.frame.size.width
        
        authorLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        dateLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        commentLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true

            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: margin)
            avatarView.autoSetDimensionsToSize(avatarView.frame.size)
            avatarView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: margin, relation: .GreaterThanOrEqual)
            
            authorLabel.autoPinEdge(.Top, toEdge: .Top, ofView: avatarView, withOffset: margin)
            authorLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: margin)
            authorLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            authorLabel.autoSetDimension(.Height, toSize: 26, relation: .GreaterThanOrEqual)
            
            commentLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorLabel, withOffset: margin)
            commentLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: dateLabel)
            commentLabel.autoPinEdge(.Left, toEdge: .Left, ofView: authorLabel)
            commentLabel.autoPinEdge(.Right, toEdge: .Right, ofView: authorLabel, withOffset: margin)
            
            dateLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: margin)
            dateLabel.autoPinEdge(.Left, toEdge: .Left, ofView: authorLabel)
            dateLabel.autoPinEdge(.Right, toEdge: .Right, ofView: authorLabel)
            dateLabel.autoSetDimension(.Height, toSize: 26, relation: .GreaterThanOrEqual)
                        
            editView.autoPinEdge(.Right, toEdge: .Right, ofView: self)
            editView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
            editView.autoPinEdge(.Top, toEdge: .Top, ofView: self)
            editView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        }
        
        super.updateConstraints()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        layoutAttributes.frame = {
            
            var frame = layoutAttributes.frame
            frame.size.height = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            
            return CGRectIntegral(frame)
        }()
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.text = nil
        commentLabel.attributedText = nil
        dateLabel.text = nil
        avatarView.imageView.image = nil
        showEditView(false)
    }
    
    func showEditView(show: Bool) {
        editView.hidden = !show
    }
}

extension ShotDetailsCommentCollectionViewCell {
    
    func deleteButtonDidTap(_: UIButton) {
        deleteActionHandler?()
    }
    
    func cancelButtonDidTap(_: UIButton) {
        showEditView(false)
    }
}

extension ShotDetailsCommentCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsCommentCollectionViewCell)
    }
}
