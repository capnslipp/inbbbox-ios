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
            itemSize = CGSize(width: BucketCollectionViewCell.preferredWidth,
                height: BucketCollectionViewCell.preferredHeight)
            let widthDependendSpacing = CGFloat((CGRectGetWidth(collectionView.bounds) - 2 * BucketCollectionViewCell.preferredWidth) / 3)
            sectionInset = UIEdgeInsets(top: widthDependendSpacing, left: widthDependendSpacing, bottom: widthDependendSpacing, right: widthDependendSpacing)
            minimumLineSpacing = widthDependendSpacing
        }
    }
}
