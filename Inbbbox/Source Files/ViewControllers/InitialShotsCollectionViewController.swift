//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class InitialShotsCollectionViewController: UICollectionViewController, InitialShotsAnimationManagerDelegate, PresentationStepViewController {

    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate?
    var animationManager = InitialShotsAnimationManager()

//    NGRTemp: temporary implementation - remove after adding real shots
    var shots = ["shot1", "shot2", "shot3"]

//    MARK: - Life cycle


    @available(*, unavailable, message = "Use init() or init(collectionViewLayout:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        guard let collectionView = collectionView else {
            return
        }

        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


        animationManager.startAnimationWithCompletion() {
            self.presentationStepViewControllerDelegate?.presentationStepViewControllerDidFinishPresenting(self)
        }
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animationManager.visibleItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - InitialShotsAnimationManagerDelegate

    func collectionViewForAnimationManager(animationManager: InitialShotsAnimationManager) -> UICollectionView? {
        return collectionView
    }

    func itemsForAnimationManager(animationManager: InitialShotsAnimationManager) -> [AnyObject] {
        return shots
    }

//    MARK: - PresentationStepViewController

    var viewController: UIViewController {
        return self
    }
}
