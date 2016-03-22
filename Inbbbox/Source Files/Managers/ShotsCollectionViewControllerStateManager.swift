//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum ShotsCollectionViewControllerState {
    case Onboarding, InitialAnimations, Normal
}

class ShotsCollectionViewControllerStateManager {

    var currentState: ShotsCollectionViewControllerState

    init() {
        let onboarding = NSUserDefaults.standardUserDefaults().boolForKey("Onboarding")
        currentState = onboarding ? .Onboarding : .InitialAnimations
    }

    var collectionViewLayout: UICollectionViewLayout {
        switch currentState {
        case .Onboarding, .Normal:
            return ShotsCollectionViewFlowLayout()
        case .InitialAnimations:
            return InitialAnimationsShotsCollectionViewLayout()
        }
    }
}
