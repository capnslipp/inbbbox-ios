//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.pagingEnabled = true
            collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapCollectionView:")
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
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - Actions

    func didTapCollectionView(_: UITapGestureRecognizer) {
//         NGRTemp: temporary implementation
//         NGRTodo: move to custom view controller transition
        if let collectionView = collectionView {
            let initialShotsCollectionViewLayout = collectionView.collectionViewLayout as! InitialShotsCollectionViewLayout
            collectionView.performBatchUpdates({
                initialShotsCollectionViewLayout.bottomCellOffset = 1000
            }, completion: {
                (_) in
                collectionView.setCollectionViewLayout(ShotsCollectionViewFlowLayout(), animated: false)
            })
        }
    }
}
