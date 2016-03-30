//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import ZFDragableModalTransition

class ShotsNormalStateHandler: NSObject, ShotsStateHandler {

    let shotsRequester =  ShotsRequester()
    let likesProvider = APIShotsProvider(page: 1, pagination: 100)
    var modalTransitionAnimator: ZFModalTransitionAnimator?
    var likedShots = [ShotType]()
    private let likesToFetch: UInt = 200

    weak var shotsCollectionViewController: ShotsCollectionViewController?
    weak var delegate: ShotsStateHandlerDelegate?

    var state: ShotsCollectionViewController.State {
        return .Normal
    }

    var nextState: ShotsCollectionViewController.State? {
        return nil
    }

    var tabBarInteractionEnabled: Bool {
        return true
    }

    var tabBarAlpha: CGFloat {
        return 1.0
    }

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }
    
    var collectionViewInteractionEnabled: Bool {
        return true
    }
    
    var collectionViewScrollEnabled: Bool {
        return true
    }
    
    func prepareForPresentingData() {
        firstly {
            fetchLikedShots()
        }.then {
            self.shotsCollectionViewController?.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
        }
    }
    
    func presentData() {
        shotsCollectionViewController?.collectionView?.reloadData()
    }
}

// MARK: UICollecitonViewDataSource
extension ShotsNormalStateHandler {
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
        cell.liked = self.isShotLiked(shot)
        cell.delegate = self
        cell.swipeCompletion = { [weak self] action in
            switch action {
            case .Like:
                self?.likeShot(shot)
            case .Bucket:
                self?.likeShot(shot)
                self?.presentShotBucketsViewController(shot)
            case .Comment:
                self?.presentShotDetailsViewControllerWithShot(shot, scrollToMessages: true)
            case .DoNothing:
                break
            }
        }
        return cell
    }
}

// MARK: UICollecitonViewDelegate
extension ShotsNormalStateHandler {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return
        }
        let shot = shotsCollectionViewController.shots[indexPath.row]
        presentShotDetailsViewControllerWithShot(shot, scrollToMessages: false)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return
        }
        if indexPath.row == shotsCollectionViewController.shots.count - 6 {
            firstly {
                shotsCollectionViewController.shotsProvider.nextPage()
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
}

// MARK: UIScrollViewDelegate
extension ShotsNormalStateHandler {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translationInView(scrollView.superview).y < 0 {
            AnalyticsManager.trackUserActionEvent(.SwipeDown)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = shotsCollectionViewController?.collectionView else {
            return
        }
        let blur = min(scrollView.contentOffset.y % CGRectGetHeight(scrollView.bounds), CGRectGetHeight(scrollView.bounds) - scrollView.contentOffset.y % CGRectGetHeight(scrollView.bounds)) / (CGRectGetHeight(scrollView.bounds) / 2)
        
        for cell in collectionView.visibleCells() {
            if let shotCell = cell as? ShotCollectionViewCell {
                shotCell.shotImageView.applyBlur(blur)
            }
        }
    }
}

extension ShotsNormalStateHandler: ShotCollectionViewCellDelegate {

    func shotCollectionViewCellDidStartSwiping(_: ShotCollectionViewCell) {
        shotsCollectionViewController?.collectionView?.scrollEnabled = false
        shotsCollectionViewController?.collectionView?.allowsSelection = false
    }

    func shotCollectionViewCellDidEndSwiping(_: ShotCollectionViewCell) {
        shotsCollectionViewController?.collectionView?.scrollEnabled = true
        shotsCollectionViewController?.collectionView?.allowsSelection = true
    }
}

// MARK: Private methods
private extension ShotsNormalStateHandler {

    func presentShotBucketsViewController(shot: ShotType) {
        let shotBucketsViewController = ShotBucketsViewController(shot: shot, mode: .AddToBucket)
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotBucketsViewController)
        
        shotBucketsViewController.transitioningDelegate = modalTransitionAnimator
        shotBucketsViewController.modalPresentationStyle = .Custom
        shotsCollectionViewController?.tabBarController?.presentViewController(shotBucketsViewController, animated: true, completion: nil)
    }
    
    func presentShotDetailsViewControllerWithShot(shot: ShotType, scrollToMessages: Bool) {
        
        shotsCollectionViewController?.definesPresentationContext = true
        
        let shotDetailsViewController = ShotDetailsViewController(shot: shot)
        shotDetailsViewController.shouldScrollToMostRecentMessage = scrollToMessages
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)
        
        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom
        
        shotsCollectionViewController?.tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }

    func isShotLiked(shot: ShotType) -> Bool {
        return likedShots.contains{ $0.identifier == shot.identifier }
    }

    func likeShot(shot: ShotType) {
        if isShotLiked(shot) {
            return
        }

        firstly {
            shotsRequester.likeShot(shot)
        }.then { Void -> Void in
            self.shotsCollectionViewController?.collectionView?.reloadData()
            self.likedShots.append(shot)
        }.error { error in
            // NGRTemp: Need mockups for error message view
        }
    }
    
    func fetchLikedShots() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            firstly {
                likesProvider.provideLikedShots(likesToFetch)
            }.then { shots -> Void in
                if let shots = shots {
                    self.likedShots = shots
                }
            }.then(fulfill).error(reject)
        }
    }
}

