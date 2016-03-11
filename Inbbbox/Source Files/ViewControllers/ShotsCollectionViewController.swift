//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import ZFDragableModalTransition

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    var animationManager = ShotsAnimator()
    var shotsRequester =  ShotsRequester()
    let shotsProvider = ShotsProvider()
    private var didFinishInitialAnimations = false
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)
    lazy var viewControllerPresenter: DefaultViewControllerPresenter = DefaultViewControllerPresenter(presentingViewController: self)
    var modalTransitionAnimator: ZFModalTransitionAnimator?

//    NGRTemp: temporary implementation - Maybe we should download shots when the ball is jumping? Or just activity indicator will be enough?

    var shots = [ShotType]()
    var likedShots = [ShotType]()

    private var shouldAskForMoreShots = true

    convenience init() {
        self.init(collectionViewLayout: InitialShotsCollectionViewLayout())

        animationManager.delegate = self
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView, tabBarController = tabBarController else {
            return
        }

        collectionView.backgroundView = ShotsCollectionBackgroundView()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
        collectionView.userInteractionEnabled = false
        tabBarController.tabBar.userInteractionEnabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.shotsProvider.provideShots()
            }.then { shots -> Void in
                self.shots = shots ?? []
                if self.shots.count > 0 {
                    self.animationManager.startAnimationWithCompletion() {
                        self.collectionView?.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
                        self.didFinishInitialAnimations = true
                        self.collectionView?.reloadData()
                        self.tabBarController?.tabBar.userInteractionEnabled = true
                        self.collectionView?.userInteractionEnabled = true
                    }
                } else {
                    self.tabBarController?.tabBar.userInteractionEnabled = true
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return didFinishInitialAnimations ? shots.count : animationManager.visibleItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)

        let shot = shots[indexPath.item]

        let shouldBlurShotImage = !didFinishInitialAnimations && indexPath.row != 0
        let blur = shouldBlurShotImage ? CGFloat(1) : CGFloat(0)
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL, blur: blur)
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

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let shot = shots[indexPath.row]
        presentShotDetailsViewControllerWithShot(shot, scrollToMessages: false)
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == shots.count - 6 && shouldAskForMoreShots {
            firstly {
                shotsProvider.nextPage()
            }.then { shots -> Void in
                if let shots = shots {
                    self.shots.appendContentsOf(shots)
                    self.collectionView?.reloadData()
                }
                self.shouldAskForMoreShots = !(shots == nil || shots?.count == 0)
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }

    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = collectionView else {
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

private extension ShotsCollectionViewController {
    
    func isShotLiked(shot: ShotType) -> Bool {
        return likedShots.contains{ $0.identifier == shot.identifier }
    }
    
    func likeShot(shot: ShotType) {
        if self.isShotLiked(shot) {
            return
        }
        
        firstly {
            self.shotsRequester.likeShot(shot)
        }.then { Void -> Void in
            self.collectionView?.reloadData()
            self.likedShots.append(shot)
        }.error { error in
            // NGRToDo handle error and show alert
        }
    }
    
    func presentShotDetailsViewControllerWithShot(shot: ShotType, scrollToMessages: Bool) {
        
        definesPresentationContext = true
        
        let shotDetailsViewController = ShotDetailsViewController(shot: shot)
        shotDetailsViewController.shouldScrollToMostRecentMessage = scrollToMessages
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)
        
        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom
        
        tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }
    
    func presentShotBucketsViewController(shot: ShotType) {
        let shotBucketsViewController = ShotBucketsViewController(shot: shot, mode: .AddToBucket)
        shotBucketsViewController.modalPresentationStyle = .OverFullScreen
        presentViewController(shotBucketsViewController, animated: true, completion: nil)
    }
}

extension ShotsCollectionViewController: ShotsAnimatorDelegate {

    func collectionViewForShotsAnimator(animator: ShotsAnimator) -> UICollectionView? {
        return collectionView
    }

    func itemsForShotsAnimator(animationManager: ShotsAnimator) -> [ShotType] {
        return Array(shots.prefix(3))
    }
}

extension ShotsCollectionViewController: ShotCollectionViewCellDelegate {

    func shotCollectionViewCellDidStartSwiping(_: ShotCollectionViewCell) {
        collectionView?.scrollEnabled = false
    }
    func shotCollectionViewCellDidEndSwiping(_: ShotCollectionViewCell) {
        collectionView?.scrollEnabled = true
    }
}
