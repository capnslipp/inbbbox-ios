//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ShotsInitialAnimationsDataSource: ShotsDataSource {

    func itemsCountForShots(shots: [ShotType], collectionView: UICollectionView, section: Int) -> Int {
        return 0
    }

    func cellForShots(shots: [ShotType], collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
