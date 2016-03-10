//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ShotCollectionViewCellDelegate: class {
    func shotCollectionViewCellDidStartSwiping(shotCollectionViewCell: ShotCollectionViewCell)
    func shotCollectionViewCellDidEndSwiping(shotCollectionViewCell: ShotCollectionViewCell)
}

class ShotCollectionViewCell: UICollectionViewCell {

    enum Action {
        case DoNothing
        case Like
        case Bucket
        case Comment
    }

    let shotImageView = ShotImageView.newAutoLayoutView()
    let likeImageView = DoubleImageView(firstImage: UIImage(named: "ic-like-swipe"), secondImage: UIImage(named: "ic-like-swipe-filled"))
    let plusImageView = UIImageView(image: UIImage(named: "ic-plus"))
    let bucketImageView = DoubleImageView(firstImage: UIImage(named: "ic-bucket-swipe"), secondImage: UIImage(named: "ic-bucket-swipe-filled"))
    let commentImageView = DoubleImageView(firstImage: UIImage(named: "ic-comment"), secondImage: UIImage(named: "ic-comment-filled"))
    let gifLabel = GifIndicatorView()
    private(set) var likeImageViewLeftConstraint: NSLayoutConstraint?
    private(set) var likeImageViewWidthConstraint: NSLayoutConstraint?
    private(set) var plusImageViewWidthConstraint: NSLayoutConstraint?
    private(set) var bucketImageViewWidthConstraint: NSLayoutConstraint?
    private(set) var commentImageViewRightConstraint: NSLayoutConstraint?
    private(set) var commentImageViewWidthConstraint: NSLayoutConstraint?

    
    var viewClass = UIView.self
    var swipeCompletion: (Action -> Void)?
    weak var delegate: ShotCollectionViewCellDelegate?

    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private let doNothingActionRange = (min: CGFloat(-50), max: CGFloat(50))
    private let likeActionRange = (min: CGFloat(50), max: CGFloat(150))
    private let bucketActionRange = (min: CGFloat(150), max: CGFloat(200))
    private let commentActionRange = (min: CGFloat(-100), max: CGFloat(-50))
    
    private var didSetConstraints = false
    var previousXTranslation: CGFloat = 0

    var liked = false {
        didSet {
            if liked {
                self.likeImageView.displaySecondImageView()
            } else {
                self.likeImageView.displayFirstImageView()
            }
        }
    }
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
        
        gifLabel.configureForAutoLayout()
        contentView.addSubview(gifLabel)

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
            
            gifLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            gifLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)

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
            let xTranslation = panGestureRecognizer.translationInView(self.contentView).x
            let selectedAction = self.selectedActionForSwipeXTranslation(xTranslation)
            animateCellAction(selectedAction) {
                self.swipeCompletion?(selectedAction)
                self.delegate?.shotCollectionViewCellDidEndSwiping(self)
            }
        default:
            let xTranslation = self.panGestureRecognizer.translationInView(self.contentView).x
            adjustConstraintsForSwipeXTranslation(xTranslation)
            adjustActionImageViewForXTranslation(xTranslation)
            previousXTranslation = xTranslation
        }
    }

//    MARK: - Helpers

    private func adjustConstraintsForSwipeXTranslation(xTranslation: CGFloat) {
        if xTranslation > bucketActionRange.max || xTranslation < commentActionRange.min {
            return
        }
        
        shotImageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, xTranslation, 0)
        likeImageViewLeftConstraint?.constant = abs(xTranslation) * 0.2
        likeImageViewWidthConstraint?.constant = min(abs(xTranslation * 0.6), likeImageView.intrinsicContentSize().width)

        let secondActionWidthConstant = max((abs(xTranslation * 0.6) - likeActionRange.min), 0)
        plusImageViewWidthConstraint?.constant = min(secondActionWidthConstant, plusImageView.intrinsicContentSize().width)
        plusImageView.alpha = min((abs(xTranslation) - likeActionRange.min) / 70, 1)

        bucketImageViewWidthConstraint?.constant = min(secondActionWidthConstant, bucketImageView.intrinsicContentSize().width)
        
        commentImageViewRightConstraint?.constant = -abs(xTranslation) * 0.2
        commentImageViewWidthConstraint?.constant = min(abs(xTranslation * 0.6), commentImageView.intrinsicContentSize().width)
    }
    
    private func adjustActionImageViewForXTranslation(xTranslation: CGFloat) {
        if xTranslation >= likeActionRange.min && xTranslation > previousXTranslation && likeImageView.isFirstImageVisible() && !liked {
            UIView.animate(animations: {
                self.likeImageView.displaySecondImageView()
            })
        } else if xTranslation < likeActionRange.min && xTranslation < previousXTranslation && likeImageView.isSecondImageVisible() && !liked {
            UIView.animate(animations: {
                self.likeImageView.displayFirstImageView()
            })
        } else if xTranslation >= bucketActionRange.min && bucketImageView.isFirstImageVisible() {
            UIView.animate(animations: {
                self.bucketImageView.displaySecondImageView()
            })
        } else if xTranslation < bucketActionRange.min && bucketImageView.isSecondImageVisible()  {
            UIView.animate(animations: {
                self.bucketImageView.displayFirstImageView()
            })
        } else if xTranslation <= commentActionRange.max && xTranslation < previousXTranslation && commentImageView.isFirstImageVisible() {
            UIView.animate(animations: {
                self.commentImageView.displaySecondImageView()
            })
        } else if xTranslation > commentActionRange.max && xTranslation > previousXTranslation && commentImageView.isSecondImageVisible() {
            UIView.animate(animations: {
                self.commentImageView.displayFirstImageView()
            })
        }
    }

    private func selectedActionForSwipeXTranslation(xTranslation: CGFloat) -> Action {
        if doNothingActionRange.min...doNothingActionRange.max ~= xTranslation {
            return .DoNothing
        } else if likeActionRange.min...likeActionRange.max ~= xTranslation {
            return .Like
        } else if xTranslation > likeActionRange.max   {
            return .Bucket
        } else {
            return .Comment
        }
    }
    
    private func animateCellAction(action: Action, completion: (() -> ())?) {
        switch action {
            case .Like:
                bucketImageView.hidden = true
                plusImageView.hidden = true
                commentImageView.hidden = true
                viewClass.animateWithDescriptor(ShotCellLikeActionAnimationDescriptor(shotCell: self, swipeCompletion: completion))
            case .Bucket:
                commentImageView.hidden = true
                viewClass.animateWithDescriptor(ShotCellBucketActionAnimationDescriptor(shotCell: self, swipeCompletion: completion))
            default:
                viewClass.animateWithDescriptor(ShotCellRestoreInitialStateAnimationDescriptor(shotCell: self, swipeCompletion: completion))
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
