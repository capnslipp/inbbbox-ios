//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsStateHandlersProvider {

    var currentState: ShotsCollectionViewController.State {
        return .Normal
    }

    var shotsStateHandler: ShotsStateHandler {
        switch currentState {
        case .Onboarding:
            return ShotsOnboardingStateHandler()
        case .InitialAnimations:
            return ShotsInitialAnimationsStateHandler()
        case .Normal:
            return ShotsNormalStateHandler()
        }
    }
}
