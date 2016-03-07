//
//  ShotDetailsCommentCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

private var avatarSize: CGSize {
    return CGSize(width: 32, height: 32)
}

private var horizontalSpaceBetweenAvatarAndText: CGFloat {
    return 15
}

class ShotDetailsCommentCollectionViewCell: UICollectionViewCell {
    
    var deleteActionHandler: (Void -> Void)?
    
    let avatarView = AvatarView(size: avatarSize, bordered: false)
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
        
        authorLabel.numberOfLines = 0
        contentView.addSubview(authorLabel)

        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(commentLabel)
        
        dateLabel.numberOfLines = 0
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
        
        let preferredMaxLayoutWidth = frame.size.width - (self.dynamicType.maximumContentWidth ?? 0)
        
        authorLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        dateLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        commentLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let verticalSpacing = self.dynamicType.verticalInteritemSpacing
            let insets = self.dynamicType.contentInsets

            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: insets.left)
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: insets.top)
            avatarView.autoSetDimensionsToSize(avatarView.frame.size)
            avatarView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: insets.bottom, relation: .GreaterThanOrEqual)
            
            authorLabel.autoPinEdge(.Top, toEdge: .Top, ofView: authorLabel.superview!, withOffset: insets.top)
            authorLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: horizontalSpaceBetweenAvatarAndText)
            authorLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: insets.right)
            authorLabel.autoSetDimension(.Height, toSize: 20, relation: .GreaterThanOrEqual)
            
            commentLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorLabel, withOffset: verticalSpacing)
            commentLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: dateLabel)
            commentLabel.autoPinEdge(.Left, toEdge: .Left, ofView: authorLabel)
            commentLabel.autoPinEdge(.Right, toEdge: .Right, ofView: authorLabel, withOffset: insets.right)
            
            dateLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: insets.bottom)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.attributedText = nil
        commentLabel.attributedText = nil
        dateLabel.attributedText = nil
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

extension ShotDetailsCommentCollectionViewCell: AutoSizable {
    
    static var maximumContentWidth: CGFloat? {
        return  contentInsets.left + contentInsets.right + avatarSize.width + horizontalSpaceBetweenAvatarAndText
    }
    
    static var minimumRequiredHeight: CGFloat {
        return contentInsets.top + contentInsets.bottom + avatarSize.height
    }
    
    static var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10)
    }
    
    static var verticalInteritemSpacing: CGFloat {
        return 5
    }
}

extension ShotDetailsCommentCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsCommentCollectionViewCell)
    }
}
