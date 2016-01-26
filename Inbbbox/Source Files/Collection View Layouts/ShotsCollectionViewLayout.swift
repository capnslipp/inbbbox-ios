//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewFlowLayout: UICollectionViewFlowLayout {

//    Mark: - UICollectionViewLayout

    override func prepareLayout() {
        if let collectionView = collectionView {
            let fixedLeftMargin = CGFloat(28)
            let fixedRightMargin = CGFloat(27)
            let calculatedItemWidth = round(CGRectGetWidth(collectionView.bounds)) - fixedLeftMargin - fixedRightMargin
            let calculatedItemHeight = calculatedItemWidth * 3 / 4
            let calculatedVerticalSpacing = round(CGRectGetHeight(collectionView.bounds) / 2 - calculatedItemHeight / 2)
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = CGFloat(CGRectGetHeight(collectionView.bounds) - calculatedItemHeight)
            sectionInset = UIEdgeInsets(top: calculatedVerticalSpacing, left: 0, bottom: calculatedVerticalSpacing, right: 0)
        }
    }
}
