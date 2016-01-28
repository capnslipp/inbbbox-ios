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
            let calculatedItemWidth = (round(CGRectGetWidth(collectionView.bounds)) - 3 * spacings.itemMargin) / 2
            let calculatedItemHeight = calculatedItemWidth * itemHeightToWidthRatio
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = spacings.itemMargin
            sectionInset = UIEdgeInsets(top: spacings.sectionMargin, left: spacings.sectionMargin, bottom: spacings.sectionMargin, right: spacings.sectionMargin)
        }
    }
}
