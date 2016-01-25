//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import KFSwiftImageLoader

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    var animationManager = ShotsAnimator()
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

        guard let collectionView = collectionView else {
            return
        }

        // NGRTemp: temporary implementation - I wonder what should be enabled by default.
        Settings.StreamSource.NewToday = true

        collectionView.backgroundView = ShotsCollectionBackgroundView()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
        tabBarController?.tabBar.userInteractionEnabled = false
        collectionView.userInteractionEnabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.shotsProvider.provideShots()
                }.then { shots -> Void in
                    self.shots = shots
                    self.animationManager.startAnimationWithCompletion() {
                        self.collectionView?.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
                        self.didFinishInitialAnimations = true
                        self.collectionView?.reloadData()
                        self.tabBarController?.tabBar.userInteractionEnabled = true
                        self.collectionView?.userInteractionEnabled = true
                    }
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
        let shot = self.shots[indexPath.item]
        cell.delegate = self
        // NGRTemp: temporary implementation - image should probably be downloaded earlier
        cell.shotImageView.loadImageFromURL(shot.image.normalURL, placeholderImage: UIImage(named: "shot-menu"))
        cell.swipeCompletion = {
            print(shot)
        }
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        definesPresentationContext = true

        let shotDetailsVC = ShotDetailsViewController()
        shotDetailsVC.modalPresentationStyle = .OverCurrentContext
        shotDetailsVC.delegate = self

        viewControllerPresenter.presentViewController(shotDetailsVC, animated: true, completion: nil)
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
