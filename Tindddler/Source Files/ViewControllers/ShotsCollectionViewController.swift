//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let shotCollectionViewCellIdentifier = "ShotCollectionViewCellIdentifier"

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ShotCollectionViewCell.self, forCellWithReuseIdentifier: shotCollectionViewCellIdentifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        collectionView?.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(shotCollectionViewCellIdentifier, forIndexPath: indexPath)
    }

//    MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin = CGFloat(10.0)
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) - margin * 2, 100)
    }
}
