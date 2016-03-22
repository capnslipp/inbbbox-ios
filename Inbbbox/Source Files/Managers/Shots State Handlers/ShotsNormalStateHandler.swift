//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ShotsNormalStateHandler: ShotsStateHandler {

    weak var delegate: ShotsStateHandlerDelegate?

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }

    func itemsCountForShots(shots: [ShotType], collectionView: UICollectionView, section: Int) -> Int {
        return shots.count
    }

    func cellForShots(shots: [ShotType], collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        let shot = shots[indexPath.item]
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL)
        cell.gifLabel.hidden = !shot.animated
        return cell
    }
}
