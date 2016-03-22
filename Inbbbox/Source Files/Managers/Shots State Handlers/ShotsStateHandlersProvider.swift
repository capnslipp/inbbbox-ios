//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsStateHandlersProvider {

    var currentState: ShotsCollectionViewController.State {
        return .Normal
    }
    
    let shotsOnboardingStateHandler = ShotsOnboardingStateHandler()
    let shotsInitialAnimationsStateHandler = ShotsInitialAnimationsStateHandler()
    let shotsNormalStateHandler = ShotsNormalStateHandler()

    var shotsStateHandler: ShotsStateHandler {
        switch currentState {
        case .Onboarding:
            return shotsOnboardingStateHandler
        case .InitialAnimations:
            return shotsInitialAnimationsStateHandler
        case .Normal:
            return shotsNormalStateHandler
        }
    }
}
