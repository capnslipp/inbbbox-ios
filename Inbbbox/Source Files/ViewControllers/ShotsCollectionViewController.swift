//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class ShotsCollectionViewController: UICollectionViewController {

//    MARK: - Life cycle

    @available(*, unavailable, message="Use init() or init(collectionViewLayout:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(collectionViewLayout: ShotsCollectionViewFlowLayout())
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.pagingEnabled = true
            collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
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
}
