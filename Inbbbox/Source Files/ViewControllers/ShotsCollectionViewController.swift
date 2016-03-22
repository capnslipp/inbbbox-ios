//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ShotsCollectionViewController: UICollectionViewController {

    var stateManager: ShotsCollectionViewControllerStateManager
    let shotsProvider = ShotsProvider()
    var shots = [ShotType]()
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)

//    MARK - Life cycle

    @available(*, unavailable, message="Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        stateManager = ShotsCollectionViewControllerStateManager()
        super.init(collectionViewLayout: stateManager.collectionViewLayout)
    }

//    MARK - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundView = ShotsCollectionBackgroundView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.shotsProvider.provideShots()
            }.then { shots -> Void in
                if let shots = shots {
                    self.shots = shots
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }
}
