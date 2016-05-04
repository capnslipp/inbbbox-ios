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

    private var indexPathsNeededImageUpdate = [NSIndexPath]()

    func prepareForPresentingData() {
        firstly {
            fetchLikedShots()
        }.then { () -> Void in
            self.updateLikeImage()
        }.error { error in
            // NGRTemp: Need mockups for error message view
        }
    }

    func presentData() { /* empty by design */ }
}

// MARK: UICollecitonViewDataSource
extension ShotsNormalStateHandler {
    func collectionView(collectionView: UICollectionView,
            numberOfItemsInSection section: Int) -> Int {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return 0
        }
        return shotsCollectionViewController.shots.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath
            indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return UICollectionViewCell()
        }

        let cell: ShotCollectionViewCell =
                collectionView.dequeueReusableClass(ShotCollectionViewCell.self,
                                      forIndexPath: indexPath,
                                              type: .Cell)

        let shot = shotsCollectionViewController.shots[indexPath.item]

        cell.shotImageView.activityIndicatorView.startAnimating()

        indexPathsNeededImageUpdate.append(indexPath)
        lazyLoadImage(shot.shotImage, forCell: cell, atIndexPath: indexPath)

        cell.gifLabel.hidden = !shot.animated
        cell.liked = self.isShotLiked(shot)
        cell.delegate = self
        cell.swipeCompletion = { [weak self] action in

            guard let certainSelf = self else { return }

            switch action {
            case .Like:
                firstly {
                    certainSelf.likeShot(shot)
                }.then {
                    cell.liked = true
                }
            case .Bucket:
                firstly {
                    certainSelf.likeShot(shot)
                }.then {
                    cell.liked = true
                }
                certainSelf.presentShotBucketsViewController(shot)
            case .Comment:
                certainSelf.presentShotDetailsViewControllerWithShot(shot, scrollToMessages: true)
            case .DoNothing:
                break
            }
        }
        return cell
    }
}

// MARK: UICollecitonViewDelegate
extension ShotsNormalStateHandler {

    func collectionView(collectionView: UICollectionView,
            didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else { return }

        let shot = shotsCollectionViewController.shots[indexPath.row]
        presentShotDetailsViewControllerWithShot(shot, scrollToMessages: false)
    }

    func collectionView(collectionView: UICollectionView,
            willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let shotsCollectionViewController = shotsCollectionViewController else { return }

        if indexPath.row == shotsCollectionViewController.shots.count - 6 {
            firstly {
                shotsCollectionViewController.shotsProvider.nextPage()
            }.then { [weak self] shots -> Void in
                if let shots = shots, shotsCollectionViewController = self?.shotsCollectionViewController {
                    shotsCollectionViewController.shots.appendContentsOf(shots)
                    shotsCollectionViewController.collectionView?.reloadData()
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
            }
        }
    }

    func collectionView(collectionView: UICollectionView,
            didEndDisplayingCell cell: UICollectionViewCell,
            forItemAtIndexPath indexPath: NSIndexPath) {
        if let index = indexPathsNeededImageUpdate.indexOf(indexPath) {
            indexPathsNeededImageUpdate.removeAtIndex(index)
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
        guard let collectionView = shotsCollectionViewController?.collectionView else { return }

        let blur = min(scrollView.contentOffset.y % CGRectGetHeight(scrollView.bounds),
                CGRectGetHeight(scrollView.bounds) - scrollView.contentOffset.y %
                CGRectGetHeight(scrollView.bounds)) / (CGRectGetHeight(scrollView.bounds) / 2)

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
        modalTransitionAnimator =
        CustomTransitions.pullDownToCloseTransitionForModalViewController(shotBucketsViewController)

        shotBucketsViewController.transitioningDelegate = modalTransitionAnimator
        shotBucketsViewController.modalPresentationStyle = .Custom
        shotsCollectionViewController?.tabBarController?.presentViewController(
                shotBucketsViewController, animated: true, completion: nil)
    }

    func presentShotDetailsViewControllerWithShot(shot: ShotType, scrollToMessages: Bool) {

        shotsCollectionViewController?.definesPresentationContext = true

        let shotDetailsViewController = ShotDetailsViewController(shot: shot)
        shotDetailsViewController.shouldScrollToMostRecentMessage = scrollToMessages

        modalTransitionAnimator =
        CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)

        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom

        shotsCollectionViewController?.tabBarController?.presentViewController(
                shotDetailsViewController, animated: true, completion: nil)
    }

    func isShotLiked(shot: ShotType) -> Bool {
        return likedShots.contains { $0.identifier == shot.identifier }
    }

    func likeShot(shot: ShotType) -> Promise<Void> {
        if isShotLiked(shot) {
            return Promise()
        }

        return Promise() { fulfill, reject in
            firstly {
                shotsRequester.likeShot(shot)
            }.then { () -> Void in
                self.likedShots.append(shot)
                fulfill()
            }.error { error in
                // NGRTemp: Need mockups for error message view
                reject(error)
            }
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

    func updateLikeImage() {
        guard let
            viewController = shotsCollectionViewController,
            collectionView = viewController.collectionView
        else {
            return
        }
        let visibleShot = collectionView.indexPathsForVisibleItems().map { return viewController.shots[$0.item] }.first
        let visibleCell = collectionView.visibleCells().first as? ShotCollectionViewCell

        if let shot = visibleShot, cell = visibleCell {
            cell.liked = isShotLiked(shot)
        }
    }
}

// MARK: Lazy loading of image

private extension ShotsNormalStateHandler {

    func lazyLoadImage(shotImage: ShotImageType, forCell cell: ShotCollectionViewCell,
            atIndexPath indexPath: NSIndexPath) {
        let teaserImageLoadingCompletion: UIImage -> Void = { [weak self] image in

            guard let certainSelf = self
                where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else {
                return
             }
            cell.shotImageView.activityIndicatorView.stopAnimating()
            cell.shotImageView.originalImage = image
            cell.shotImageView.image = image
        }
        let imageLoadingCompletion: UIImage -> Void = { [weak self] image in

            guard let certainSelf = self
                where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else {
                return
            }

            cell.shotImageView.originalImage = image
            cell.shotImageView.image = image
        }
        LazyImageProvider.lazyLoadImageFromURLs(
            (shotImage.teaserURL, shotImage.normalURL, nil),
            teaserImageCompletion: teaserImageLoadingCompletion,
            normalImageCompletion: imageLoadingCompletion
        )
    }
}
