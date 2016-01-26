//
//  BucketsCollectionViewLayout.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BucketsCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
       
        if let collectionView = collectionView {
            let spacing = CGFloat(28)
            let calculatedItemWidth = (round(CGRectGetWidth(collectionView.bounds)) - 3 * spacing) / 2
            
            // NGRTemp: width to height ratio will change because it contains also labels with info about bucket
            let calculatedItemHeight = calculatedItemWidth
            itemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
            minimumLineSpacing = spacing
            sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        }
    }
}
