//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ShotCollectionViewCellDelegate: class {
    func shotCollectionViewCellDidStartSwiping(shotCollectionViewCell: ShotCollectionViewCell)
    func shotCollectionViewCellDidEndSwiping(shotCollectionViewCell: ShotCollectionViewCell)
}

class ShotCollectionViewCell: UICollectionViewCell {

    let shotImageView = UIImageView.newAutoLayoutView()
    let panGestureRecognizer = UIPanGestureRecognizer()
    private var didSetConstraints = false
    var swipeCompletion: (Void -> Void)?
    weak var delegate: ShotCollectionViewCellDelegate?

    // MARK: - Life cycle

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // NGRTemp: temporary implementation -
        // added temporary image to see changes in UI without shots downloaded
        shotImageView.image = UIImage(named: "shot-menu")

        shotImageView.clipsToBounds = true
        shotImageView.layer.cornerRadius = 5
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
        // NGRTemp: temporary implementation
        switch panGestureRecognizer.state {
            case .Began:
                self.delegate?.shotCollectionViewCellDidStartSwiping(self)
            case .Ended, .Cancelled, .Failed:
                UIView.animateWithDuration(0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.9,
                    options: .CurveEaseInOut,
                    animations: {
                        self.shotImageView.transform = CGAffineTransformIdentity
                    }, completion: { _ in
                        self.swipeCompletion?()
                        self.delegate?.shotCollectionViewCellDidEndSwiping(self)
                    })
            default:
                let translation = panGestureRecognizer.translationInView(self.contentView)
                shotImageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, translation.x, 0)
        }
    }
}

extension ShotCollectionViewCell: HeightAware {

    static var prefferedHeight: CGFloat {
        return CGFloat(240)
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
