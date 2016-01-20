//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class ShotsCollectionViewController: UICollectionViewController, ShotsAnimationManagerDelegate {

//    MARK: - Life cycle

    var animationManager = ShotsAnimationManager()

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

        tabBarController?.tabBar.hidden = true

        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

    //    MARK: - InitialShotsAnimationManagerDelegate

    func collectionViewForAnimationManager(animationManager: ShotsAnimationManager) -> UICollectionView? {
        return collectionView
    }

    func itemsForAnimationManager(animationManager: ShotsAnimationManager) -> [AnyObject] {
        return shots.prefix(3) as! [AnyObject]
    }
}
