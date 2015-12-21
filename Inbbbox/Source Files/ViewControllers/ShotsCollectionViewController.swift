//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.pagingEnabled = true
            collectionView.registerClass(ShotCollectionViewCell.self, forCellWithReuseIdentifier: ShotCollectionViewCell.preferredReuseIdentifier)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTapCollectionView:"))
            collectionView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // NGRTodo: implement me!
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ShotCollectionViewCell.preferredReuseIdentifier, forIndexPath: indexPath)
    }

//    MARK: - Actions

    func didTapCollectionView(sender: AnyObject) {
//         NGRTemp: temporary implementation
//         NGRTodo: move to custom view controller transition
        if let collectionView = collectionView {
            let initialShotsCollectionViewLayout = collectionView.collectionViewLayout as! InitialShotsCollectionViewLayout
            collectionView.performBatchUpdates({
                initialShotsCollectionViewLayout.bottomCellOffset = 1000
            }, completion: { (finished) in
                collectionView.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
            })
        }
    }
}
