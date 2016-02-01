//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ShotCollectionViewCellDelegate: class {
    func shotCollectionViewCellDidStartSwiping(shotCollectionViewCell: ShotCollectionViewCell)
    func shotCollectionViewCellDidEndSwiping(shotCollectionViewCell: ShotCollectionViewCell)
}

enum ShotCollectionViewCellAction {
    case Like
    case Bucket
    case Comment
}

class ShotCollectionViewCell: UICollectionViewCell {

    let shotImageView = UIImageView.newAutoLayoutView()
    let likeImageView = UIImageView(image: UIImage(named: "ic-like-swipe"))
    let bucketImageView = UIImageView(image: UIImage(named: "ic-bucket-swipe"))
    let commentImageView = UIImageView(image: UIImage(named: "ic-comment"))

    var viewClass = UIView.self
    var swipeCompletion: (ShotCollectionViewCellAction -> Void)?
    weak var delegate: ShotCollectionViewCellDelegate?

    private let plusImageView = UIImageView(image: UIImage(named: "ic-plus"))
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let likeActionTreshold = CGFloat(100)
    private let bucketActionTreshold = CGFloat(200)
    private let commentActionTreshold = CGFloat(-100)
    private var likeImageViewLeftConstraint: NSLayoutConstraint?
    private var likeImageViewWidthConstraint: NSLayoutConstraint?
    private var plusImageViewWidthConstraint: NSLayoutConstraint?
    private var bucketImageViewWidthConstraint: NSLayoutConstraint?
    private var commentImageViewRightConstraint: NSLayoutConstraint?
    private var commentImageViewWidthConstraint: NSLayoutConstraint?
    private var didSetConstraints = false

    // MARK: - Life cycle

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.pinkColor()
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true

        likeImageView.configureForAutoLayout()
        contentView.addSubview(likeImageView)

        plusImageView.configureForAutoLayout()
        contentView.addSubview(plusImageView)

        bucketImageView.configureForAutoLayout()
        contentView.addSubview(bucketImageView)

        commentImageView.configureForAutoLayout()
        contentView.addSubview(commentImageView)

        contentView.addSubview(shotImageView)

        panGestureRecognizer.addTarget(self, action: "didSwipeCell:")
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool{
        return true
    }

    override func updateConstraints() {

        if !didSetConstraints {
            shotImageView.autoPinEdgesToSuperviewEdges()

            likeImageViewWidthConstraint = likeImageView.autoSetDimension(.Width, toSize: 0)
            likeImageView.autoConstrainAttribute(.Height, toAttribute: .Width, ofView: likeImageView,
                withMultiplier: likeImageView.intrinsicContentSize().height / likeImageView.intrinsicContentSize().width)
            likeImageViewLeftConstraint = likeImageView.autoPinEdgeToSuperviewEdge(.Left)
            likeImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            plusImageViewWidthConstraint = plusImageView.autoSetDimension(.Width, toSize: 0)
            plusImageView.autoConstrainAttribute(.Height, toAttribute: .Width, ofView: plusImageView,
                withMultiplier: plusImageView.intrinsicContentSize().height / plusImageView.intrinsicContentSize().width)
            plusImageView.autoPinEdge(.Left, toEdge: .Right, ofView: likeImageView, withOffset: 15)
            plusImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            bucketImageViewWidthConstraint = bucketImageView.autoSetDimension(.Width, toSize: 0)
            bucketImageView.autoConstrainAttribute(.Height, toAttribute: .Width, ofView: bucketImageView,
                withMultiplier: bucketImageView.intrinsicContentSize().height / bucketImageView.intrinsicContentSize().width)
            bucketImageView.autoPinEdge(.Left, toEdge: .Right, ofView: plusImageView, withOffset: 15)
            bucketImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            commentImageViewWidthConstraint = commentImageView.autoSetDimension(.Width, toSize: 0)
            commentImageView.autoConstrainAttribute(.Height, toAttribute: .Width, ofView: commentImageView,
                withMultiplier: commentImageView.intrinsicContentSize().height / commentImageView.intrinsicContentSize().width)
            commentImageViewRightConstraint = commentImageView.autoPinEdgeToSuperviewEdge(.Right)
            commentImageView.autoAlignAxisToSuperviewAxis(.Horizontal)

            didSetConstraints = true
        }

        super.updateConstraints()
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = panGestureRecognizer.velocityInView(self.contentView)
        return fabs(velocity.x) > fabs(velocity.y)
    }

    // MARK: - Actions

    func didSwipeCell(panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .Began:
            self.delegate?.shotCollectionViewCellDidStartSwiping(self)
        case .Ended, .Cancelled, .Failed:
            viewClass.animateWithDuration(0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.9,
                    options: .CurveEaseInOut,
                    animations: {
                        self.shotImageView.transform = CGAffineTransformIdentity
                    }, completion: { _ in
                let xTranslation = panGestureRecognizer.translationInView(self.contentView).x
                let selectedAction = self.selectedActionForSwipeXTranslation(xTranslation)
                self.swipeCompletion?(selectedAction)
                self.delegate?.shotCollectionViewCellDidEndSwiping(self)
            })
        default:
            let xTranslation = self.panGestureRecognizer.translationInView(self.contentView).x
            adjustConstraintsForSwipeXTranslation(xTranslation)
        }
    }

//    MARK: - Helpers

    private func adjustConstraintsForSwipeXTranslation(xTranslation: CGFloat) {
        if xTranslation > bucketActionTreshold || xTranslation < commentActionTreshold {
            return
        }
        shotImageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, xTranslation, 0)

        likeImageViewLeftConstraint?.constant = abs(xTranslation) * 0.2
        likeImageViewWidthConstraint?.constant = min(abs(xTranslation * 0.6), likeImageView.intrinsicContentSize().width)
        likeImageView.alpha = min(abs(xTranslation) / 70, 1)

        let displaySecondActionTreshold = CGFloat(50)
        let secondActionWidthConstant = max((abs(xTranslation * 0.6) - displaySecondActionTreshold), 0)
        plusImageViewWidthConstraint?.constant = min(secondActionWidthConstant, plusImageView.intrinsicContentSize().width)
        plusImageView.alpha = min((abs(xTranslation) - displaySecondActionTreshold) / 70, 1)

        bucketImageViewWidthConstraint?.constant = min(secondActionWidthConstant, bucketImageView.intrinsicContentSize().width)
        plusImageView.alpha = min((abs(xTranslation) - displaySecondActionTreshold) / 70, 1)

        commentImageViewRightConstraint?.constant = -abs(xTranslation) * 0.2
        commentImageViewWidthConstraint?.constant = min(abs(xTranslation * 0.6), commentImageView.intrinsicContentSize().width)
        commentImageView.alpha = min(abs(xTranslation) / 70, 1)
    }

    private func selectedActionForSwipeXTranslation(xTranslation: CGFloat) -> ShotCollectionViewCellAction {
        if 0...likeActionTreshold ~= xTranslation {
            return .Like
        } else if xTranslation > 100 {
            return .Bucket
        } else {
            return .Comment
        }
    }
}

extension ShotCollectionViewCell: Reusable {

    static var reuseIdentifier: String {
        return "ShotCollectionViewCellIdentifier"
    }
}

extension ShotCollectionViewCell: UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
