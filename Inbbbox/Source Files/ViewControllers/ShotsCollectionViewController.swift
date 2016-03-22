//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsCollectionViewController: UICollectionViewController {

    enum State {
        case Onboarding, InitialAnimations, Normal
    }

    var currentState: State

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(state: State) {
        currentState = state
        var collectionViewLayout: UICollectionViewLayout
        switch state {
        case .Onboarding, .Normal:
            collectionViewLayout = ShotsCollectionViewFlowLayout()
        case .InitialAnimations:
            collectionViewLayout = InitialAnimationsShotsCollectionViewLayout()
        }
        super.init(collectionViewLayout: collectionViewLayout)
    }
}
