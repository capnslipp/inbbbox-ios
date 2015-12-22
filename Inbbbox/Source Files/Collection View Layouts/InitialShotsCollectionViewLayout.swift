//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class InitialShotsCollectionViewLayout: UICollectionViewLayout {

    private(set) var itemsCount = 0
    var bottomCellOffset = CGFloat(20)

//    MARK: - Life cycle

    convenience init(itemsCount: Int) {
        self.init()
        self.itemsCount = itemsCount
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    MARK: - UICollectionViewLayout

    override func collectionViewContentSize() -> CGSize {
        return collectionView!.bounds.size
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesForVisibleElements = [UICollectionViewLayoutAttributes]()
        for indexPath in indexPathsOfItemsInRect(rect) {
            layoutAttributesForVisibleElements.append(layoutAttributesForItemAtIndexPath(indexPath)!)
        }
        return layoutAttributesForVisibleElements
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        if let collectionView = collectionView {
            let margin = CGFloat(30)
            let indexMultiplier = CGFloat(indexPath.item)
            layoutAttributes.size = CGSize(width: CGRectGetWidth(collectionView.bounds) - margin * 2 * (indexMultiplier + 1), height: ShotCollectionViewCell.prefferedHeight)
            layoutAttributes.center = CGPoint(x: collectionView.center.x, y: collectionView.center.y + bottomCellOffset * indexMultiplier)
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

//    MARK: - Helpers

    private func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = []
        for itemIndex in 0 ..< itemsCount {
            indexPaths.append(NSIndexPath(forItem: itemIndex, inSection: 0))
        }
        return indexPaths
    }
}
