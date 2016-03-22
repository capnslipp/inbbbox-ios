//
//  ShotsDataSource.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 3/22/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotsDataSource {
    func itemsCountForShots(shots: [ShotType], collectionView: UICollectionView, section: Int) -> Int

    func cellForShots(shots: [ShotType], collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell
}
