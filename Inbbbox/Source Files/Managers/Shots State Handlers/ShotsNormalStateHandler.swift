//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import ZFDragableModalTransition

class ShotsNormalStateHandler: NSObject, ShotsStateHandler {

    let shotsRequester =  ShotsRequester()
    let shotsProvider = ShotsProvider()
    var modalTransitionAnimator: ZFModalTransitionAnimator?

    weak var shotsCollectionViewController: ShotsCollectionViewController?
    weak var delegate: ShotsStateHandlerDelegate?

    var state: ShotsCollectionViewController.State {
        return .Normal
    }

    var nextState: ShotsCollectionViewController.State? {
        return nil
    }

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }
    var tabBarInteractionEnabled: Bool {
        return true
    }
    var collectionViewInteractionEnabled: Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return 0
        }
        return shotsCollectionViewController.shots.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return UICollectionViewCell()
        }
        
        let cell: ShotCollectionViewCell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        
        let shot = shotsCollectionViewController.shots[indexPath.item]
        
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL)
        cell.gifLabel.hidden = !shot.animated
        cell.delegate = shotsCollectionViewController
        cell.swipeCompletion = { [weak self] action in
            switch action {
            case .Like:
                self?.shotsRequester.likeShot(shot)
            case .Bucket:
                self?.shotsRequester.likeShot(shot)
                self?.presentShotBucketsViewController(shot, shotsCollectionViewController: self?.shotsCollectionViewController)
            case .Comment:
                self?.presentShotDetailsViewControllerWithShot(shot, scrollToMessages: true, shotsCollectionViewController: self?.shotsCollectionViewController)
            case .DoNothing:
                break
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return
        }
        let shot = shotsCollectionViewController.shots[indexPath.row]
        presentShotDetailsViewControllerWithShot(shot, scrollToMessages: false, shotsCollectionViewController: shotsCollectionViewController)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return
        }
        if indexPath.row == shotsCollectionViewController.shots.count - 6 {
            firstly {
                shotsProvider.nextPage()
                }.then { [weak self] shots -> Void in
                    if let shots = shots, let shotsCollectionViewController = self?.shotsCollectionViewController {
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
