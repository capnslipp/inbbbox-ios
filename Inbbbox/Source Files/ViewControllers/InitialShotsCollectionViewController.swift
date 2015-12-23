//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol InitialShotsCollectionViewLayoutDelegate: class {
    func initialShotsCollectionViewDidFinishAnimations()
}

final class InitialShotsCollectionViewController: UICollectionViewController {

    weak var delegate: InitialShotsCollectionViewLayoutDelegate?
    var numberOfItems = 0

//    MARK: - Life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init() {
        self.init(collectionViewLayout: InitialShotsCollectionViewLayout())
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        delay(0.1) {
            self.insertItem()
        }

        delay(0.2) {
            self.insertItem()
        }

        delay(0.3) {
            self.insertItem()
        }

        delay(0.6) {
            self.deleteItem()
        }

        delay(0.7) {
            self.deleteItem()
        }

        if let delegate = delegate {
            delay(0.9) {
                delegate.initialShotsCollectionViewDidFinishAnimations()
            }
        }
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // NGRTodo: implement me!
        return numberOfItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - Helpers

    private func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
        dispatch_time(
        DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
        ),
                dispatch_get_main_queue(), closure)
    }

    private func insertItem() {
        if let collectionView = collectionView {
            numberOfItems += 1
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: numberOfItems - 1, inSection: 0)])
        }
    }

    private func deleteItem() {
        if let collectionView = collectionView {
            numberOfItems -= 1
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: numberOfItems, inSection: 0)])
        }
    }
}
