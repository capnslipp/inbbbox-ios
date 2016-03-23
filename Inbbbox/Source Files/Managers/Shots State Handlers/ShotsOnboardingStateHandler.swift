//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Haneke

class ShotsOnboardingStateHandler: NSObject, ShotsStateHandler {

    weak var shotsCollectionViewController: ShotsCollectionViewController?
    weak var delegate: ShotsStateHandlerDelegate?
    let onboardinShotsCount = 3
    let stepsImages = [
        (key: "onboarding-step1", image: UIImage(named: "onboarding-step1")!),
        (key: "onboarding-step2", image: UIImage(named: "onboarding-step2")!),
        (key: "onboarding-step3", image: UIImage(named: "onboarding-step3")!)
    ].sort() { $0.key < $1.key }
    
    var state: ShotsCollectionViewController.State {
        return .Onboarding
    }

    var nextState: ShotsCollectionViewController.State? {
        return .Normal
    }

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }
    
    var tabBarInteractionEnabled: Bool {
        return false
    }
    
    var collectionViewInteractionEnabled: Bool {
        return true
    }
    
    func presentData() {
        shotsCollectionViewController?.collectionView?.reloadData()
        for (index, stepImage) in stepsImages.enumerate() {
            Shared.imageCache.set(value:stepImage.image, key: stepImage.key, formatName: CacheManager.imageFormatName) { _ in
                self.shotsCollectionViewController?.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            }
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return onboardinShotsCount
        }
        return onboardinShotsCount + shotsCollectionViewController.shots.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < onboardinShotsCount {
            return cellForOnboardingShot(collectionView, indexPath: indexPath)
        } else {
            return cellForShot(collectionView, indexPath: indexPath)
        }
    }
    
//    MARK - Helpers
    
    private func cellForShot(collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return ShotCollectionViewCell()
        }
        let shot = shotsCollectionViewController.shots[0]
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL)
        cell.gifLabel.hidden = !shot.animated
        return cell
    }
    
    private func cellForOnboardingShot(collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        let stepImageKey = stepsImages[indexPath.row].key
        print(stepImageKey)
        cell.shotImageView.loadShotImageFromURL(NSURL(string: stepImageKey)!);
        cell.gifLabel.hidden = true
        return cell
    }
}
