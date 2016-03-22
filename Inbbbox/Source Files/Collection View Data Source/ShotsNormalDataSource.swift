//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsNormalDataSource: NSObject, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
//
//        let shot = shots[indexPath.item]
//
//        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL, blur: blur)
//        cell.gifLabel.hidden = !shot.animated
//        cell.delegate = self
//        cell.swipeCompletion = { [weak self] action in
//            switch action {
//            case .Like:
//                self?.likeShot(shot)
//            case .Bucket:
//                self?.likeShot(shot)
//                self?.presentShotBucketsViewController(shot)
//            case .Comment:
//                self?.presentShotDetailsViewControllerWithShot(shot, scrollToMessages: true)
//            case .DoNothing:
//                break
//            }
//        }
        return UICollectionViewCell()
    }
}
