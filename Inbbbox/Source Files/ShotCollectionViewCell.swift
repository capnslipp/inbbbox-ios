//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotCollectionViewCell: UICollectionViewCell, HeightAware {

//    MARK: - Life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
                alpha: 1)
    }

//    MARK: - HeightAware
    static var prefferedHeight: CGFloat {
        get {
            return CGFloat(235)
        }
    }

//    MARK: - ReuseIdentifierAware
    static var preferredReuseIdentifier: String {
        get {
            return "ShotCollectionViewCellIdentifier"
        }
    }
}
