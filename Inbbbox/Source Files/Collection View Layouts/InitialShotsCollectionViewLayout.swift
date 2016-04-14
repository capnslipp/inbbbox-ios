//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class InitialShotsCollectionViewLayout: UICollectionViewLayout {

//    MARK: - UICollectionViewLayout

    override func collectionViewContentSize() -> CGSize {
        return collectionView!.bounds.size
    }

    override func layoutAttributesForElementsInRect(rect: CGRect)
                    -> [UICollectionViewLayoutAttributes]? {
        return indexPathsOfItemsInRect(rect).map {
            self.layoutAttributesForItemAtIndexPath($0)!
        }
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
                    -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        if let collectionView = collectionView {
            let spacings = CollectionViewLayoutSpacings()
            let fixedLeftMargin = CGFloat(28)
            let fixedRightMargin = CGFloat(27)
            let indexMultiplier = CGFloat(indexPath.item)
            let calculatedItemWidth = round(CGRectGetWidth(collectionView.bounds)) -
                    (fixedLeftMargin + fixedRightMargin) * (indexMultiplier + 1)
            let calculatedItemHeight = calculatedItemWidth * spacings.shotHeightToWidthRatio
            layoutAttributes.size = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            layoutAttributes.center = CGPoint(x: collectionView.center.x,
                    y: collectionView.center.y +
                    spacings.initialShotsLayoutBottomCellOffset * indexMultiplier)
            layoutAttributes.zIndex = -indexPath.row
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        var boundsChanged = true
        if let collectionView = collectionView {
            let oldBounds = collectionView.bounds
            boundsChanged = !CGSizeEqualToSize(oldBounds.size, newBounds.size)
        }
        return boundsChanged
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(indexPath: NSIndexPath)
                    -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = layoutAttributesForItemAtIndexPath(indexPath)
        if let collectionView = collectionView, layoutAttributes = layoutAttributes {
            layoutAttributes.center = collectionView.center
            layoutAttributes.alpha = 0
        }
        return layoutAttributes
    }

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(indexPath: NSIndexPath)
                    -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = layoutAttributesForItemAtIndexPath(indexPath)
        if let collectionView = collectionView, layoutAttributes = layoutAttributes {
            layoutAttributes.center = CGPoint(x: CGRectGetMidX(collectionView.bounds),
                    y: CGRectGetMaxY(collectionView.bounds) +
                    CGRectGetMaxY(layoutAttributes.bounds))
            layoutAttributes.alpha = 0
        }
        return layoutAttributes
    }

//    MARK: - Helpers

    private func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = []
        if let collectionView = collectionView {
            for itemIndex in 0 ..< collectionView.numberOfItemsInSection(0) {
                indexPaths.append(NSIndexPath(forItem: itemIndex, inSection: 0))
            }
        }
        return indexPaths
    }

}
