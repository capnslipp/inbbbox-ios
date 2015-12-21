//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class InitialShotsCollectionViewLayout: UICollectionViewLayout {

    var itemsCount = 0

//    MARK: - Life cycle

    convenience init(itemsCount: Int){
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

        var layoutAttributesForVisibleElements: [UICollectionViewLayoutAttributes] = []
        for indexPath in indexPathsOfItemsInRect(rect) {
            layoutAttributesForVisibleElements.append(layoutAttributesForItemAtIndexPath(indexPath)!)
        }
        return layoutAttributesForVisibleElements
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        if let collectionView = collectionView {
            let margin = CGFloat(30)
            let offset = CGFloat(20)
            let indexMultiplier = CGFloat(indexPath.item)
            layoutAttributes.size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - margin * 2 * (indexMultiplier + 1), ShotCollectionViewCell.prefferedHeight)
            layoutAttributes.center = CGPointMake(collectionView.center.x, collectionView.center.y + offset * indexMultiplier)
            layoutAttributes.zIndex = -indexPath.row
        }
        return layoutAttributes
    }

    private func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = []
        for itemIndex in 0..<itemsCount{
            indexPaths.append(NSIndexPath(forItem: itemIndex, inSection: 0))
        }
        return indexPaths
    }
}
