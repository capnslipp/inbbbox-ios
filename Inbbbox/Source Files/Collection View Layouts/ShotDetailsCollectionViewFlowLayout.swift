//
//  ShotDetailsCollectionViewLayout.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 05.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDetailsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        scrollDirection = .Vertical
        if var width = collectionView?.bounds.width {
            width = width - (sectionInset.left + sectionInset.right)
            estimatedItemSize = CGSizeMake(width, 100)
        }
        minimumLineSpacing = 0
    }
}
