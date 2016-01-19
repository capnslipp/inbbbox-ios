//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsPresentationStep: PresentationStep {

//    MARK: - PresentationStep

    weak var presentationStepDelegate: PresentationStepDelegate?

    var presentationStepViewController: PresentationStepViewController {
        let shotsViewController = ShotsCollectionViewController()
        CenterButtonTabBarController(shotsViewController: shotsViewController)
        return shotsViewController
    }
}
