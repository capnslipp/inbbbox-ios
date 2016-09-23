//
//  ShotAuthorCompactView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 25.05.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import PureLayout

class ShotAuthorCompactView: UIView {

    // Public
    lazy var avatarView: AvatarView = AvatarView(size: self.avatarSize,
                                                 bordered: false)
    var authorLabel = UILabel.newAutoLayoutView()

    lazy var likesImageView: UIImageView = UIImageView(image: UIImage(named: "ic-likes-count"))
    var likesLabel = UILabel.newAutoLayoutView()

    lazy var commentsImageView: UIImageView = UIImageView(image: UIImage(named: "ic-comment-count"))
    var commentsLabel = UILabel.newAutoLayoutView()

    struct ViewData {
        let author: String
        let avatarURL: NSURL
        let likesCount: UInt
        let commentsCount: UInt
    }

    var viewData: ViewData? {
        didSet {
            authorLabel.text = viewData?.author
            let placeholder = UIImage(named: "ic-account-nopicture")
            avatarView.imageView.loadImageFromURL((viewData?.avatarURL)!, placeholderImage: placeholder)
            likesLabel.text = "\(viewData?.likesCount ?? 0)"
            commentsLabel.text = "\(viewData?.commentsCount ?? 0)"
        }
    }

    // Private
    private var didSetupConstraints = false
    private let avatarSize = CGSize(width: 16, height: 16)
    private let likesSize = CGSize(width: 17, height: 16)
    private let commentsSize = CGSize(width: 18, height: 16)

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        avatarView.backgroundColor = .clearColor()
        addSubview(avatarView)

        authorLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        authorLabel.textColor = .followeeTextGrayColor()
        addSubview(authorLabel)

        addSubview(likesImageView)

        likesLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        likesLabel.textColor = .followeeTextGrayColor()
        addSubview(likesLabel)

        addSubview(commentsImageView)

        commentsLabel.font = UIFont.helveticaFont(.Neue, size: 10)
        commentsLabel.textColor = .followeeTextGrayColor()
        addSubview(commentsLabel)
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func updateConstraints() {
        if !didSetupConstraints {

            avatarView.autoSetDimensionsToSize(self.avatarSize)
            avatarView.autoPinEdgeToSuperviewEdge(.Leading)
            avatarView.autoAlignAxisToSuperviewAxis(.Horizontal)

            authorLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: avatarView, withOffset: 3)
            authorLabel.autoAlignAxisToSuperviewAxis(.Horizontal)

            commentsLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 3)
            commentsLabel.autoAlignAxisToSuperviewAxis(.Horizontal)

            commentsImageView.autoSetDimensionsToSize(self.commentsSize)
            commentsImageView.autoPinEdge(.Trailing, toEdge: .Leading, ofView: commentsLabel, withOffset: -3)
            commentsImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            likesLabel.autoPinEdge(.Trailing, toEdge: .Leading, ofView: commentsImageView, withOffset: -8)
            likesLabel.autoAlignAxisToSuperviewAxis(.Horizontal)

            likesImageView.autoSetDimensionsToSize(self.likesSize)
            likesImageView.autoPinEdge(.Trailing, toEdge: .Leading, ofView: likesLabel, withOffset: -3)
            likesImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            didSetupConstraints = true
        }

        super.updateConstraints()
    }
}
