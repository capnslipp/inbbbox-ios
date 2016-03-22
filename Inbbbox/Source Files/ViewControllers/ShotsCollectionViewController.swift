//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewController: UICollectionViewController {

    var stateManager: ShotsCollectionViewControllerStateManager

    @available(*, unavailable, message="Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        stateManager = ShotsCollectionViewControllerStateManager()
        super.init(collectionViewLayout: stateManager.collectionViewLayout)
    }
}
