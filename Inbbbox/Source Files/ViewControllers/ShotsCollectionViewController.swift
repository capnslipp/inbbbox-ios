//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class ShotsCollectionViewController: UICollectionViewController, ShotsAnimationManagerDelegate {

//    MARK: - Life cycle

    var animationManager = ShotsAnimationManager()
    private var didFinishInitialAnimations = false
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)

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

        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
        tabBarController?.tabBar.userInteractionEnabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            self.animationManager.startAnimationWithCompletion() {
                self.collectionView?.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
                self.didFinishInitialAnimations = true
                self.collectionView?.reloadData()
                self.tabBarController?.tabBar.userInteractionEnabled = true
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
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - InitialShotsAnimationManagerDelegate

    func collectionViewForAnimationManager(animationManager: ShotsAnimationManager) -> UICollectionView? {
        return collectionView
    }

    func itemsForAnimationManager(animationManager: ShotsAnimationManager) -> [AnyObject] {
        return Array(shots.prefix(3))
    }
}
