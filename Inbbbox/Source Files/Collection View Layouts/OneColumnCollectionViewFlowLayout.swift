//
//  OneColumnCollectionViewFlowLayout.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class OneColumnCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var itemHeightToWidthRatio = CGFloat(1)
    var containsHeader = false

    override func prepareLayout() {

        if let collectionView = collectionView {
            let spacings = CollectionViewLayoutSpacings()
            let calculatedItemWidth = round(CGRectGetWidth(collectionView.bounds)) -
                    2 * spacings.itemMargin
            let calculatedItemHeight = calculatedItemWidth * itemHeightToWidthRatio
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = spacings.minimumLineSpacing
            sectionInset = UIEdgeInsets(top: spacings.sectionMarginVertical,
                                       left: spacings.sectionMarginHorizontal,
                                     bottom: spacings.sectionMarginVertical,
                                      right: spacings.sectionMarginHorizontal)
            if containsHeader {
                headerReferenceSize = CGSize(width: CGRectGetWidth(collectionView.bounds),
                                            height: 150)
            }
        }
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect)
                    -> [UICollectionViewLayoutAttributes]? {

        let attributes = super.layoutAttributesForElementsInRect(rect)

        guard let collectionView = collectionView else {
            return attributes
        }

        let insets = collectionView.contentInset
        let offset = collectionView.contentOffset
        let minY = -insets.top

        if offset.y < minY {
            let deltaY = fabsf(Float(offset.y - minY))

            attributes?.forEach {
                if $0.representedElementKind == UICollectionElementKindSectionHeader {
                    var headerRect = $0.frame
                    headerRect.size.height = max(minY, headerReferenceSize.height + CGFloat(deltaY))
                    headerRect.origin.y = headerRect.origin.y - CGFloat(deltaY)
                    $0.frame =  headerRect
                    $0.zIndex = 64
                }
            }
        }
        return attributes
    }
}
