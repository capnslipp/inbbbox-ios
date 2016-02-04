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
    
    override func prepareLayout() {
        
        if let collectionView = collectionView {
            let spacings = CollectionViewLayoutSpacings()
            let calculatedItemWidth = round(CGRectGetWidth(collectionView.bounds)) - 2 * spacings.itemMargin
            let calculatedItemHeight = calculatedItemWidth * itemHeightToWidthRatio
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = spacings.minimumLineSpacing
            sectionInset = UIEdgeInsets(top: spacings.sectionMarginVertical, left: spacings.sectionMarginHorizontal, bottom: spacings.sectionMarginVertical, right: spacings.sectionMarginHorizontal)
        }
    }
}
