//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotCollectionViewCell: UICollectionViewCell, HeightAware, Reusable {

//    MARK: - Life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

//        NGRTemp: temporary implementation
        contentView.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
                alpha: 1)
    }

//    MARK: - HeightAware
    static var prefferedHeight: CGFloat {
        get {
            return CGFloat(240)
        }
    }

//    MARK: - Reusable
    static var reuseIdentifier: String {
        get {
            return "ShotCollectionViewCellIdentifier"
        }
    }
}
