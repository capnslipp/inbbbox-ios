//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsStateHandlersProvider {

    func shotsStateHandlerForState(state: ShotsCollectionViewController.State) -> ShotsStateHandler {
        switch state {
        case .Onboarding:
            return ShotsOnboardingStateHandler()
        case .InitialAnimations:
            return ShotsInitialAnimationsStateHandler()
        case .Normal:
            return ShotsNormalStateHandler()
        }
    }
}
