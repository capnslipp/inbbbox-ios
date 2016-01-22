//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    var animationManager = ShotsAnimator()
    private var didFinishInitialAnimations = false
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)
    lazy var viewControllerPresenter: DefaultViewControllerPresenter = DefaultViewControllerPresenter(presentingViewController: self)

//    NGRTemp: temporary implementation - remove after adding real shots
    var shots = ["shot1", "shot2", "shot3", "shot4", "shot5", "shot6", "shot7", "shot8", "shot9", "shot10"]


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

        collectionView.backgroundView = ShotsCollectionBackgroundView()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
        tabBarController?.tabBar.userInteractionEnabled = false
        collectionView.userInteractionEnabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            self.animationManager.startAnimationWithCompletion() {
                self.collectionView?.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
                self.didFinishInitialAnimations = true
                self.collectionView?.reloadData()
                self.tabBarController?.tabBar.userInteractionEnabled = true
                self.collectionView?.userInteractionEnabled = true
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
        cell.delegate = self
        // NGRTemp: temporary implementation
        let shot = self.shots[indexPath.item]
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

    func itemsForShotsAnimator(animationManager: ShotsAnimator) -> [AnyObject] {
        return Array(shots.prefix(3))
    }
}

extension ShotsCollectionViewController: ShotDetailsViewControllerDelegate {

    func didFinishPresentingDetails(sender: ShotDetailsViewController) {
        viewControllerPresenter.dismissViewControllerAnimated(true, completion: nil)
    }

    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        // NGRTodo: Implement it to allow swiping collection view while holding cell
        return true
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
