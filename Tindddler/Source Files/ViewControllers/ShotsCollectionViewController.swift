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
        collectionView?.pagingEnabled = true
        collectionView?.registerClass(ShotCollectionViewCell.self, forCellWithReuseIdentifier: shotCollectionViewCellIdentifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(shotCollectionViewCellIdentifier, forIndexPath: indexPath)
    }

//    MARK: - UICollectionViewDelegateFlowLayout


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin = CGFloat(30)
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) - margin * 2, ShotCollectionViewCell.prefferedHeight())
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(CGRectGetHeight(collectionView.bounds) - ShotCollectionViewCell.prefferedHeight())
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let topMargin = round(CGRectGetHeight(collectionView.bounds) / 2 - ShotCollectionViewCell.prefferedHeight() / 2)
        let bottomMargin = topMargin
        return UIEdgeInsetsMake(topMargin, 0, bottomMargin, 0)
    }
}
