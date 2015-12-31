//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsContainerViewController: UIViewController, InitialShotsCollectionViewLayoutDelegate {

    let initialShotsCollectionViewController = InitialShotsCollectionViewController()
    let shotsCollectionViewController = ShotsCollectionViewController()

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        initialShotsCollectionViewController.delegate = self
        initialShotsCollectionViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        shotsCollectionViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        addChildViewController(initialShotsCollectionViewController)
        view.addSubview(initialShotsCollectionViewController.view)
        initialShotsCollectionViewController.didMoveToParentViewController(self)
    }

//    MARK: - InitialShotsCollectionViewLayoutDelegate

    func initialShotsCollectionViewDidFinishAnimations() {
        addChildViewController(shotsCollectionViewController)
        view.addSubview(shotsCollectionViewController.view)
        shotsCollectionViewController.didMoveToParentViewController(self)

        initialShotsCollectionViewController.willMoveToParentViewController(nil)
        initialShotsCollectionViewController.view.removeFromSuperview()
        initialShotsCollectionViewController.removeFromParentViewController()
    }
}
