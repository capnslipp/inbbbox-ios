//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import KFSwiftImageLoader

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    var animationManager = ShotsAnimator()
    var localStorage = ShotsLocalStorage()
    var userStorageClass = UserStorage.self
    var imageClass = UIImage.self
    var shotOperationRequesterClass =  ShotOperationRequester.self
    private var didFinishInitialAnimations = false
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)
    lazy var viewControllerPresenter: DefaultViewControllerPresenter = DefaultViewControllerPresenter(presentingViewController: self)

//    NGRTemp: temporary implementation - Maybe we should download shots when the ball is jumping? Or just activity indicator will be enough?
    var shots = [Shot]()

    let shotsProvider = ShotsProvider()

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
        cell.swipeCompletion = { action in
            switch action {
            case .Like:
                if self.userStorageClass.currentUser != nil {
                    self.shotOperationRequesterClass.likeShot(shot.identifier)
                } else {
                    do {
                        try self.localStorage.like(shotID: shot.identifier)
                    } catch {
                    }
                }
            case .Bucket: break
            case .Comment: break
            }
        }
        cell.delegate = self
        // NGRTemp: temporary implementation - image should probably be downloaded earlier
        cell.shotImageView.loadImageFromURL(shot.image.normalURL, placeholderImage: UIImage(named: "shot-menu"))
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        definesPresentationContext = true

        let shotDetailsVC = ShotDetailsViewController()
        shotDetailsVC.modalPresentationStyle = .OverCurrentContext
        shotDetailsVC.delegate = self

        viewControllerPresenter.presentViewController(shotDetailsVC, animated: true, completion: nil)
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
                let image = imageClass.cachedImageFromURL(shot.image.normalURL, placeholderImage: UIImage(named: "shot-menu"))
                shotCell.shotImageView.image = image?.blurredImage(blur)
            }
        }
    }

    // MARK: - Helpers

    func configureInitialSettings() {
        // NGRTemp: - I wonder if there is a better place to configure initial settings other than this view controller
        Settings.StreamSource.NewToday = true
        Settings.StreamSource.PopularToday = true
        Settings.StreamSource.Debuts = true
    }
}

extension ShotsCollectionViewController: ShotsAnimatorDelegate {

    func collectionViewForShotsAnimator(animator: ShotsAnimator) -> UICollectionView? {
        return collectionView
    }

    func itemsForShotsAnimator(animationManager: ShotsAnimator) -> [Shot] {
        return Array(shots.prefix(3))
    }
}

extension ShotsCollectionViewController: ShotDetailsViewControllerDelegate {

    func didFinishPresentingDetails(sender: ShotDetailsViewController) {
        viewControllerPresenter.dismissViewControllerAnimated(true, completion: nil)
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
