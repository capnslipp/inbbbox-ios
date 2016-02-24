//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    var animationManager = ShotsAnimator()
    var imageClass = UIImage.self
    var shotsRequester =  ShotsRequester()
    let shotsProvider = ShotsProvider()
    private var didFinishInitialAnimations = false
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)
    lazy var viewControllerPresenter: DefaultViewControllerPresenter = DefaultViewControllerPresenter(presentingViewController: self)

//    NGRTemp: temporary implementation - Maybe we should download shots when the ball is jumping? Or just activity indicator will be enough?

    var shots = [ShotType]()

    private var shouldAskForMoreShots = true

    convenience init() {
        self.init(collectionViewLayout: InitialShotsCollectionViewLayout())

        animationManager.delegate = self
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        configureInitialSettings()

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
                self.animationManager.startAnimationWithCompletion() {
                    self.collectionView?.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
                    self.didFinishInitialAnimations = true
                    self.collectionView?.reloadData()
                    self.tabBarController?.tabBar.userInteractionEnabled = true
                    self.collectionView?.userInteractionEnabled = true
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

        cell.delegate = self

        cell.swipeCompletion = { [weak self] action in
            switch action {
            case .Like:
                self?.shotsRequester.likeShot(shot)
            case .Bucket: break
            case .Comment: break
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        definesPresentationContext = true

        let shotDetailsCollectionViewController = ShotDetailsViewController(shot: shots[indexPath.item])
        shotDetailsCollectionViewController.modalPresentationStyle = .OverCurrentContext
        tabBarController?.presentViewController(shotDetailsCollectionViewController, animated: true, completion: nil)
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
            if let shotCell = cell as? ShotCollectionViewCell, indexPath = collectionView.indexPathForCell(shotCell) {
                let shot = shots[indexPath.item]
                shotCell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL, blur: blur)
            }
        }
    }

    // MARK: - Helpers

    func configureInitialSettings() {
        // NGRTemp: - I wonder if there is a better place to configure initial settings other than this view controller
        Settings.StreamSource.NewToday = false
        Settings.StreamSource.PopularToday = true
        Settings.StreamSource.Debuts = false
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
