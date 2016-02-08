//
//  TwoColumnsCollectionViewFlowLayout.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TwoColumnsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var itemHeightToWidthRatio = CGFloat(1)
    
    override func prepareLayout() {
       
        if let collectionView = collectionView {
            let spacings = CollectionViewLayoutSpacings()
            let calculatedItemWidth = (round(CGRectGetWidth(collectionView.bounds)) - 3 * spacings.twoColumnsItemMargin) / 2
            let calculatedItemHeight = calculatedItemWidth * itemHeightToWidthRatio
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = spacings.twoColumnsMinimumLineSpacing
            minimumInteritemSpacing = spacings.twoColumnsMinimymInterimSpacing
            sectionInset = UIEdgeInsets(top: spacings.twoColumnsSectionMarginVertical, left: spacings.twoColumnsSectionMarginVertical, bottom: spacings.twoColumnsSectionMarginHorizontal, right: spacings.twoColumnsSectionMarginVertical)
        }
    }
}
