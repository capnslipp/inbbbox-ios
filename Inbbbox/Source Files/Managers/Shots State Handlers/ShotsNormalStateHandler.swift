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

    var collectionViewLayout: UICollectionViewLayout = ShotsCollectionViewFlowLayout()

    var collectionViewInteractionEnabled: Bool {
        return true
    }

    var collectionViewScrollEnabled: Bool {
        return true
    }

    var didLikeShotCompletionHandler: (() -> Void)?
    var didAddShotToBucketCompletionHandler: (() -> Void)?

    private var indexPathsNeededImageUpdate = [UpdateableIndexPaths]()

    func prepareForPresentingData() {
        if !UserStorage.isUserSignedIn {
            updateAuthorData()
            return
        }

        firstly {
            fetchLikedShots()
        }.then { () -> Void in
            self.updateLikeImage()
        }.then { () -> Void  in
            self.updateAuthorData()
        }.error { error in
            self.delegate?.shotsStateHandlerDidFailToFetchItems(error)
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

        let cell: ShotCollectionViewCell =  collectionView.dequeueReusableClass(ShotCollectionViewCell.self,
                                                                                forIndexPath: indexPath,
                                                                                type: .Cell)

        let shot = shotsCollectionViewController.shots[indexPath.item]

        cell.shotImageView.activityIndicatorView.startAnimating()

        load(shot.shotImage, for: indexPath)

        cell.gifLabel.hidden = !shot.animated
        cell.liked = self.isShotLiked(shot)

        if let user = shot.user.name, url = shot.user.avatarURL {
            let likes = shot.likesCount, comments = shot.commentsCount
            cell.authorView.viewData = ShotAuthorCompactView
                .ViewData(author: user,
                          avatarURL: url,
                          liked: cell.liked,
                          likesCount: likes,
                          commentsCount: comments)
        }

        cell.delegate = self
        cell.swipeCompletion = { [weak self] action in

            guard let certainSelf = self else { return }

            switch action {
            case .Like:
                firstly {
                    certainSelf.likeShot(shot)
                }.then {
                    cell.liked = true
                }.then {
                    self?.didLikeShotCompletionHandler?()
                }.error { error in
                    cell.liked = false
                }
            case .Bucket:
                firstly {
                    certainSelf.likeShot(shot)
                }.then {
                    cell.liked = true
                }.error { error in
                    cell.liked = false
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

// MARK: UICollectionViewDataSourcePrefetching
extension ShotsNormalStateHandler: UICollectionViewDataSourcePrefetching {

    func collectionView(collectionView: UICollectionView, prefetchItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        guard let shotsCollectionViewController = shotsCollectionViewController else { return }

        indexPaths.forEach {
            let shot = shotsCollectionViewController.shots[$0.item]
            load(shot.shotImage, for: $0)
        }
    }

    func collectionView(collectionView: UICollectionView, cancelPrefetchingForItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        indexPathsNeededImageUpdate.removeAll()
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

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? ShotCollectionViewCell {
            cell.displayAuthor(Settings.Customization.ShowAuthor, animated: true)

            if let shotsCollectionViewController = shotsCollectionViewController {
                let shot = shotsCollectionViewController.shots[indexPath.item]
                load(shot.shotImage, for: indexPath)
            }
        }

        downloadNextPageIfNeeded(for: indexPath)
    }

    func collectionView(collectionView: UICollectionView,
            didEndDisplayingCell cell: UICollectionViewCell,
            forItemAtIndexPath indexPath: NSIndexPath) {
        indexPathsNeededImageUpdate = indexPathsNeededImageUpdate.filter { $0.indexPath != indexPath }
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
                if !DeviceInfo.shouldDowngrade() {
                    shotCell.shotImageView.applyBlur(blur)
                }
            }
        }
    }
}

// MARK: ShotCollectionViewCellDelegate

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
        shotBucketsViewController.didDismissViewControllerClosure = { [weak self] in
            self?.didAddShotToBucketCompletionHandler?()
        }
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotBucketsViewController)

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
            }.then {
                self.fetchLikedShots()
            }.then { () -> Void in
                self.updateAuthorData()
                fulfill()
            }.error { error in
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

        let visibleShot = self.visibleShot()
        let visibleCell = self.visibleCell()

        if let shot = visibleShot, cell = visibleCell {
            cell.liked = isShotLiked(shot)
        }
    }

    func updateAuthorData() {

        let visibleShot = self.visibleShot()
        let visibleCell = self.visibleCell()

        if let cell = visibleCell, var shot = visibleShot {
            cell.displayAuthor(Settings.Customization.ShowAuthor, animated: true)
            cell.liked = self.isShotLiked(shot)

            if cell.liked {
                shot = likedShots.filter({ $0.identifier == shot.identifier }).first ?? shot
            }

            if let user = shot.user.name, url = shot.user.avatarURL {
                let likes = shot.likesCount, comments = shot.commentsCount
                cell.authorView.viewData = ShotAuthorCompactView
                    .ViewData(author: user,
                              avatarURL: url,
                              liked: cell.liked,
                              likesCount: likes,
                              commentsCount: comments)
            }
        }
    }

    func visibleShot() -> ShotType? {
        guard let
            viewController = shotsCollectionViewController,
            collectionView = viewController.collectionView else {
                return nil
        }

        return collectionView.indexPathsForVisibleItems().map { return viewController.shots[$0.item] }.first
    }

    func visibleCell() -> ShotCollectionViewCell? {
        guard let
            viewController = shotsCollectionViewController,
            collectionView = viewController.collectionView else {
                return nil
        }

        return collectionView.visibleCells().first as? ShotCollectionViewCell
    }

    func load(image: ShotImageType, for indexPath: NSIndexPath) {
        indexPathsNeededImageUpdate.append(UpdateableIndexPaths(indexPath: indexPath))
        lazyLoadImage(image, for: indexPath)
    }

    func downloadNextPageIfNeeded(for indexPath: NSIndexPath) {
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
                    self.delegate?.shotsStateHandlerDidFailToFetchItems(error)
            }
        }
    }
}

// MARK: Lazy loading of image

private extension ShotsNormalStateHandler {

    /// Returns UpdateableIndexPaths object that matches given NSIndexPath (if any)
    /// - parameter indexPath: indexPath to match.
    /// - returns: Matched UpdateableIndexPaths object.
    func updateableIndexPath(for indexPath: NSIndexPath) -> UpdateableIndexPaths? {
        return indexPathsNeededImageUpdate.filter { $0.indexPath == indexPath }.first
    }

    func lazyLoadImage(shotImage: ShotImageType, for indexPath: NSIndexPath) {
        let teaserImageLoadingCompletion: UIImage -> Void = { [weak self] image in

            guard let certainSelf = self else { return }
            guard let _ = certainSelf.updateableIndexPath(for: indexPath) else { return }

            if let collectionView = certainSelf.shotsCollectionViewController?.collectionView {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ShotCollectionViewCell {
                    cell.shotImageView.activityIndicatorView.stopAnimating()
                    cell.shotImageView.originalImage = image
                    cell.shotImageView.image = image
                }
            }
        }
        let imageLoadingCompletion: UIImage -> Void = { [weak self] image in

            guard let certainSelf = self else {return}
            guard var indexPathToUpdate = certainSelf.updateableIndexPath(for: indexPath) else { return }

            if let index = certainSelf.indexPathsNeededImageUpdate.indexOf({$0 == indexPathToUpdate}) {
                indexPathToUpdate.status = .Updated
                certainSelf.indexPathsNeededImageUpdate[index] = indexPathToUpdate
            }

            if let collectionView = certainSelf.shotsCollectionViewController?.collectionView {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ShotCollectionViewCell {
                    cell.shotImageView.originalImage = image
                    cell.shotImageView.image = image
                }
            }
        }

        guard var indexPathToUpdate = self.updateableIndexPath(for: indexPath) else { return }
        if indexPathToUpdate.status == .NotStarted || indexPathToUpdate.status == .Updated {
            if let index = indexPathsNeededImageUpdate.indexOf({$0 == indexPathToUpdate}) {
                indexPathToUpdate.status = .InProgress
                indexPathsNeededImageUpdate[index] = indexPathToUpdate
            }
            LazyImageProvider.lazyLoadImageFromURLs(
                (shotImage.teaserURL, shotImage.normalURL, nil),
                teaserImageCompletion: teaserImageLoadingCompletion,
                normalImageCompletion: imageLoadingCompletion
            )
        }
    }
}
