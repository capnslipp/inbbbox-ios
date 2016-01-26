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
            let fixedLeftMargin = CGFloat(28)
            let fixedRightMargin = CGFloat(27)
            let fixedVerticalSpacing = CGFloat(28)
            let calculatedItemWidth = round(CGRectGetWidth(collectionView.bounds)) - fixedLeftMargin - fixedRightMargin
            let calculatedItemHeight = calculatedItemWidth * itemHeightToWidthRatio
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = fixedVerticalSpacing
            sectionInset = UIEdgeInsets(top: fixedVerticalSpacing, left: 0, bottom: fixedVerticalSpacing, right: 0)
        }
    }
}
