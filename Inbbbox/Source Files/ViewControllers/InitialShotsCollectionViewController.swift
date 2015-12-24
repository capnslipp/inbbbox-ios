//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol InitialShotsCollectionViewLayoutDelegate: class {
    func initialShotsCollectionViewDidFinishAnimations()
}

final class InitialShotsCollectionViewController: UICollectionViewController, InitialShotsAnimationManagerDelegate {

    weak var delegate: InitialShotsCollectionViewLayoutDelegate?
    var shots = ["shot1", "shot2", "shot3"]
    var animationManager = InitialShotsAnimationManager()

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

        animationManager.delegate = self

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.shotsCollectionViewBackgroundColor()
            collectionView.pagingEnabled = true
            collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


        animationManager.startAnimationWithCompletion() {
            if let delegate = self.delegate {
                delegate.initialShotsCollectionViewDidFinishAnimations()
            }
        }
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // NGRTodo: implement me!
        return animationManager.visibleItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - InitialShotsAnimationManagerDelegate

    func collectionViewForAnimationManager(_ animationManager: InitialShotsAnimationManager) -> UICollectionView? {
        return collectionView
    }

    func itemsForAnimationManager(_ animationManager: InitialShotsAnimationManager) -> [AnyObject] {
        return shots
    }
}
