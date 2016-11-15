//
//  ShotDetailsHeaderView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout
import Haneke
import TTTAttributedLabel
import ImageViewer


private var avatarSize: CGSize {
    return CGSize(width: 48, height: 48)
}
private var margin: CGFloat {
    return 10
}

class ShotDetailsHeaderView: UICollectionReusableView {
    
    var showAttachements: Bool = false {
        didSet {
            attachementContainer.hidden = !showAttachements
        }
    }
    var attachements:[Attachement] = [Attachement]() {
        didSet {
            attachementsCollectionView.reloadData()
        }
    }
    var attachementDidTap: ((UICollectionViewCell, Attachement) -> Void)?
    var selectedAttachement: Attachement?

    var availableWidthForTitle: CGFloat {
        return avatarSize.width + 3 * margin
    }

    var maxHeight = CGFloat(0)
    var minHeight = CGFloat(0)

    var imageView: UIImageView!
    var imageDidTap: (() -> Void)?
    let avatarView = AvatarView(size: avatarSize, bordered: false)

    let closeButtonView = CloseButtonView.newAutoLayoutView()
    private let titleLabel = TTTAttributedLabel.newAutoLayoutView()
    private let overlapingTitleLabel = UILabel.newAutoLayoutView()
    private let dimView = UIView.newAutoLayoutView()
    private let imageViewCenterWrapperView = UIView.newAutoLayoutView()
    private let shadowImageView = UIImageView.newAutoLayoutView()
    private let attachementContainer = UIView.newAutoLayoutView()
    private lazy var attachementsCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())

    private var imageViewCenterWrapperBottomConstraint: NSLayoutConstraint?
    private var attachementContainerHeightConstraint: NSLayoutConstraint?

    private var didUpdateConstraints = false
    private var collapseProgress: CGFloat {
        return 1 - (frame.size.height - minHeight) / (maxHeight - minHeight)
    }

    private lazy var imageTapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        return UITapGestureRecognizer(target: self, action: #selector(shotImageDidTap(_:)))
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        clipsToBounds = true

        titleLabel.backgroundColor = .clearColor()
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)

        imageViewCenterWrapperView.clipsToBounds = true
        addSubview(imageViewCenterWrapperView)

        shadowImageView.image = UIImage(named: "DetailsShadow")
        shadowImageView.contentMode = .ScaleToFill
        addSubview(shadowImageView)

        dimView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        dimView.alpha = 0.05
        dimView.addGestureRecognizer(imageTapGestureRecognizer)
        imageViewCenterWrapperView.addSubview(dimView)

        overlapingTitleLabel.backgroundColor = .clearColor()
        overlapingTitleLabel.numberOfLines = 0
        overlapingTitleLabel.alpha = 0
        addSubview(overlapingTitleLabel)

        avatarView.imageView.image = UIImage(named: "ic-author-mugshot-nopicture")
        addSubview(avatarView)

        addSubview(closeButtonView)

        setNeedsUpdateConstraints()
        
        attachementContainer.backgroundColor = UIColor.RGBA(43, 49, 51, 1)
        insertSubview(attachementContainer, aboveSubview: titleLabel)
        
        attachementsCollectionView.registerClass(AttachementCollectionViewCell.self, forCellWithReuseIdentifier: AttachementCollectionViewCell.reuseIdentifier)
        attachementsCollectionView.backgroundColor = .clearColor()
        attachementsCollectionView.dataSource = self
        attachementsCollectionView.delegate = self
        attachementsCollectionView.showsHorizontalScrollIndicator = false
        if let layout = attachementsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSizeMake(80, 60)
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            layout.scrollDirection = .Horizontal
        }
        
        attachementContainer.addSubview(attachementsCollectionView)
    }

    deinit {
        // NGRHack: animation has to be invalidated to release AnimatableShotImageView object
        if let imageView = imageView as? AnimatableShotImageView {
            let displayLink = imageView.valueForKey("displayLink") as? CADisplayLink
            displayLink?.invalidate()
        }
    }

    @available(*, unavailable, message = "Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let progress = collapseProgress
        let absoluteProgress = max(min(progress, 1), 0)
        print("progress = \(String(progress)) absolute = \(String(absoluteProgress))")

        imageViewCenterWrapperBottomConstraint?.constant = -minHeight + minHeight * absoluteProgress

        dimView.alpha = 0.05 + 0.95 * progress
        overlapingTitleLabel.alpha = progress
    }

    override func updateConstraints() {

        if !didUpdateConstraints {
            didUpdateConstraints = true

            avatarView.autoSetDimensionsToSize(avatarSize)
            avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: titleLabel, withOffset: 20)
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)

            titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 15)
            titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            titleLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            titleLabel.autoSetDimension(.Height, toSize: minHeight)

            overlapingTitleLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: titleLabel)
            overlapingTitleLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: titleLabel)
            overlapingTitleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: titleLabel)
            overlapingTitleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: titleLabel)

            imageViewCenterWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            imageViewCenterWrapperView.autoMatchDimension(.Height, toDimension: .Width, ofView: imageViewCenterWrapperView, withMultiplier: 0.75)

            attachementContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageViewCenterWrapperView)
            attachementContainer.autoPinEdgeToSuperviewEdge(.Left)
            attachementContainer.autoPinEdgeToSuperviewEdge(.Right)
            attachementContainer.autoSetDimension(.Height, toSize: 70)
            
            attachementsCollectionView.autoSetDimension(.Height, toSize: 60)
            attachementsCollectionView.autoAlignAxisToSuperviewAxis(.Horizontal)
            attachementsCollectionView.autoPinEdgeToSuperviewEdge(.Left, withInset: 5)
            attachementsCollectionView.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)

            shadowImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageViewCenterWrapperView)
            shadowImageView.autoPinEdgeToSuperviewEdge(.Left)
            shadowImageView.autoPinEdgeToSuperviewEdge(.Right)
            shadowImageView.autoSetDimension(.Height, toSize: shadowImageView.image?.size.height ?? 0)

            dimView.autoPinEdgesToSuperviewEdges()

            closeButtonView.autoPinEdge(.Right, toEdge: .Right, ofView: imageViewCenterWrapperView, withOffset: -5)
            closeButtonView.autoPinEdge(.Top, toEdge: .Top, ofView: imageViewCenterWrapperView, withOffset: 5)
        }

        super.updateConstraints()
    }

    func setAttributedTitle(title: NSAttributedString?) {
        titleLabel.setText(title)
        overlapingTitleLabel.attributedText = {
            guard let title = title else {
                return nil
            }

            let mutableTitle = NSMutableAttributedString(attributedString: title)
            let range = NSRange(location: 0, length: title.length)
            mutableTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)

            return mutableTitle.copy() as? NSAttributedString
        }()
    }

    func setLinkInTitle(URL: NSURL, range: NSRange, delegate: TTTAttributedLabelDelegate) {
        let linkAttributes = [
                NSForegroundColorAttributeName: UIColor.pinkColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(14)
        ]
        titleLabel.linkAttributes = linkAttributes
        titleLabel.activeLinkAttributes = linkAttributes
        titleLabel.inactiveLinkAttributes = linkAttributes
        titleLabel.extendsLinkTouchArea = false
        titleLabel.addLinkToURL(URL, withRange: range)
        titleLabel.delegate = delegate
    }
}

extension ShotDetailsHeaderView {

    func setImageWithShotImage(shotImage: ShotImageType) {
        if imageView == nil {
            imageView = ShotImageView.newAutoLayoutView()
            setupImageView()
        }

        let imageCompletion: UIImage -> Void = {
            [weak self] image in
            if let imageView = self?.imageView {
                imageView.image = image
            }
        }

        LazyImageProvider.lazyLoadImageFromURLs(
            (teaserURL: shotImage.teaserURL, normalURL: shotImage.normalURL, hidpiURL: shotImage.hidpiURL),
            teaserImageCompletion: imageCompletion,
            normalImageCompletion: imageCompletion,
            hidpiImageCompletion: imageCompletion
        )
    }

    func setAnimatedImageWithUrl(url: NSURL) {
        if imageView == nil {
            imageView = AnimatableShotImageView.newAutoLayoutView()
            setupImageView()
        }
        let iv = imageView as? AnimatableShotImageView
        iv?.loadAnimatableShotFromUrl(url)
    }

    private func setupImageView() {
        imageViewCenterWrapperView.insertSubview(imageView, belowSubview: dimView)
        imageView.autoPinEdgesToSuperviewEdges()
    }
}

extension ShotDetailsHeaderView: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsHeaderView)
    }
}

extension ShotDetailsHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachements.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AttachementCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
        if let cell = cell as? AttachementCollectionViewCell, thumbnail = attachements[indexPath.row].thumbnailURL {
            cell.imageView.loadImageFromURL(thumbnail)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        attachementDidTap?(collectionView.cellForItemAtIndexPath(indexPath)!, attachements[indexPath.row])
    }
}

extension ShotDetailsHeaderView: ImageProvider {
    
    func provideImage(completion: UIImage? -> Void) {
        guard let selectedAttachementUrl = selectedAttachement?.imageURL else {
            return
        }
        Shared.imageCache.fetch(
            URL: selectedAttachementUrl,
            formatName: CacheManager.imageFormatName,
            failure: nil,
            success: { image in
                completion(image)
        })
    }
}

private extension ShotDetailsHeaderView {
    
    dynamic func shotImageDidTap(_: UITapGestureRecognizer) {
        imageDidTap?()
    }
}
