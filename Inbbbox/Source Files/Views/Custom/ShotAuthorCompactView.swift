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

    struct ViewData {
        let author: String
        let avatarURL: NSURL
    }

    var viewData: ViewData? {
        didSet {
            authorLabel.text = viewData?.author
            avatarView.imageView.loadImageFromURL((viewData?.avatarURL)!)
        }
    }

    // Private
    private var didSetupConstraints = false
    private let avatarSize = CGSize(width: 16, height: 16)

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        avatarView.backgroundColor = .clearColor()
        addSubview(avatarView)

        authorLabel.font = UIFont.helveticaFont(.Neue, size: 13)
        authorLabel.textColor = .followeeTextGrayColor()
        addSubview(authorLabel)
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

            didSetupConstraints = true
        }

        super.updateConstraints()
    }
}
