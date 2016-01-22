//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotCollectionViewCell: UICollectionViewCell {

    let shotImageView = UIImageView.newAutoLayoutView()
    private var didSetConstraints = false

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
