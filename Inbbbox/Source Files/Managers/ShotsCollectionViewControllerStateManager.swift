//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum ShotsCollectionViewControllerState {
    case Onboarding, InitialAnimations, Normal
}

class ShotsCollectionViewControllerStateManager {

    var currentState: ShotsCollectionViewControllerState
    
    let shotsCollectionViewFlowLayout = ShotsCollectionViewFlowLayout()
    let initialAnimationsShotsCollectionViewLayout = InitialAnimationsShotsCollectionViewLayout()
    
    let shotsOnboardingDataSource = ShotsOnboardingDataSource()
    let shotsInitialAnimationsDataSource = ShotsInitialAnimationsDataSource()
    let shotsNormalDataSource = ShotsNormalDataSource()

    init() {
//        let onboarding = NSUserDefaults.standardUserDefaults().boolForKey("Onboarding")
//        currentState = onboarding ? .Onboarding : .InitialAnimations
        currentState = .Normal
    }

    var collectionViewLayout: UICollectionViewLayout {
        switch currentState {
        case .Onboarding, .Normal:
            return shotsCollectionViewFlowLayout
        case .InitialAnimations:
            return initialAnimationsShotsCollectionViewLayout
        }
    }

    var shotsCollectionViewDataSource: ShotsDataSource {
        switch currentState {
        case .Onboarding:
            return shotsOnboardingDataSource
        case .InitialAnimations:
            return shotsInitialAnimationsDataSource
        case .Normal:
            return shotsNormalDataSource
        }
    }
}
