//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewFlowLayout: UICollectionViewFlowLayout {


//    Mark: - UICollectionViewLayout
    override func prepareLayout() {
        if let collectionView = collectionView {
            let margin = CGFloat(30)
            itemSize = CGSizeMake(CGRectGetWidth(collectionView.bounds) - margin * 2, ShotCollectionViewCell.prefferedHeight)

            minimumLineSpacing = CGFloat(CGRectGetHeight(collectionView.bounds) - ShotCollectionViewCell.prefferedHeight)

            let topMargin = round(CGRectGetHeight(collectionView.bounds) / 2 - ShotCollectionViewCell.prefferedHeight / 2)
            let bottomMargin = topMargin
            sectionInset = UIEdgeInsetsMake(topMargin, 0, bottomMargin, 0)
        }
    }
}
