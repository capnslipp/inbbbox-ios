//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewFlowLayout: UICollectionViewFlowLayout {

//    MARK: - UICollectionViewLayout

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesForVisibleElements = super.layoutAttributesForElementsInRect(rect)
        var newLayoutAttributesForVisibleElements: [UICollectionViewLayoutAttributes] = []
        for layoutAttributes in layoutAttributesForVisibleElements! {
            newLayoutAttributesForVisibleElements.append(layoutAttributesForItemAtIndexPath(layoutAttributes.indexPath)!)
        }
        return newLayoutAttributesForVisibleElements
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?{
        let layoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        layoutAttributes?.size = CGSizeMake(10, 10)
        return layoutAttributes
    }
}
