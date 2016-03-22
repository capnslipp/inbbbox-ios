//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import ZFDragableModalTransition

class ShotsNormalStateHandler: ShotsStateHandler {

    let shotsRequester =  ShotsRequester()
    let shotsProvider = ShotsProvider()
    var modalTransitionAnimator: ZFModalTransitionAnimator?

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }
    var tabBarInteractionEnabled: Bool {
        return true
    }
    var collectionViewInteractionEnabled: Bool {
        return true
    }

    func numberOfItems(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, section: Int) -> Int {
        return shotsCollectionViewController.shots.count
    }

    func configuredCell(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        let cell: ShotCollectionViewCell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)

        let shot = shotsCollectionViewController.shots[indexPath.item]

        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL)
        cell.gifLabel.hidden = !shot.animated
        cell.delegate = shotsCollectionViewController
        cell.swipeCompletion = { [weak self, weak shotsCollectionViewController] action in
            switch action {
            case .Like:
                self?.shotsRequester.likeShot(shot)
            case .Bucket:
                self?.shotsRequester.likeShot(shot)
                self?.presentShotBucketsViewController(shot, shotsCollectionViewController: shotsCollectionViewController)
            case .Comment:
                self?.presentShotDetailsViewControllerWithShot(shot, scrollToMessages: true, shotsCollectionViewController: shotsCollectionViewController)
            case .DoNothing:
                break
            }
        }
        return cell
    }

    func didSelectItem(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, indexPath: NSIndexPath) {
        let shot = shotsCollectionViewController.shots[indexPath.row]
        presentShotDetailsViewControllerWithShot(shot, scrollToMessages: false, shotsCollectionViewController: shotsCollectionViewController)
    }

    func willDisplayCell(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath) {
        if indexPath.row == shotsCollectionViewController.shots.count - 6 {
            firstly {
                shotsProvider.nextPage()
            }.then { shots -> Void in
                if let shots = shots {
                    shotsCollectionViewController.shots.appendContentsOf(shots)
                    shotsCollectionViewController.collectionView?.reloadData()
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }
    
//    MARK - Helpers
    
    private func presentShotBucketsViewController(shot: ShotType, shotsCollectionViewController: ShotsCollectionViewController?) {
        let shotBucketsViewController = ShotBucketsViewController(shot: shot, mode: .AddToBucket)
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotBucketsViewController)
        
        shotBucketsViewController.transitioningDelegate = modalTransitionAnimator
        shotBucketsViewController.modalPresentationStyle = .Custom
        shotsCollectionViewController?.presentViewController(shotBucketsViewController, animated: true, completion: nil)
    }

    private func presentShotDetailsViewControllerWithShot(shot: ShotType, scrollToMessages: Bool, shotsCollectionViewController: ShotsCollectionViewController?) {

        shotsCollectionViewController?.definesPresentationContext = true

        let shotDetailsViewController = ShotDetailsViewController(shot: shot)
        shotDetailsViewController.shouldScrollToMostRecentMessage = scrollToMessages

        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)

        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom

        shotsCollectionViewController?.tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }
}
