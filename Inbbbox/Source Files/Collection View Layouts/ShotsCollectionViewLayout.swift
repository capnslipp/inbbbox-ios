//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewFlowLayout: UICollectionViewFlowLayout {

//    Mark: - UICollectionViewLayout
    override func prepareLayout() {
        if let collectionView = collectionView {
            let cellMargins: UIEdgeInsets = UIEdgeInsets(top: round(CGRectGetHeight(collectionView.bounds) / 2 - ShotCollectionViewCell.prefferedHeight / 2),
                    left: CGFloat(30),
                    bottom: round(CGRectGetHeight(collectionView.bounds) / 2 - ShotCollectionViewCell.prefferedHeight / 2),
                    right: CGFloat(30))

            itemSize = CGSize(width: CGRectGetWidth(collectionView.bounds) - cellMargins.left - cellMargins.right,
                    height: ShotCollectionViewCell.prefferedHeight)
            minimumLineSpacing = CGFloat(CGRectGetHeight(collectionView.bounds) - ShotCollectionViewCell.prefferedHeight)
            sectionInset = UIEdgeInsetsMake(cellMargins.top, 0, cellMargins.bottom, 0)
        }
    }
}
