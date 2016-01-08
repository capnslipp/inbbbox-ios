//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsPresentationStep: PresentationStep, PresentationStepViewControllerDelegate {

//    MARK: - PresentationStep

    weak var presentationStepDelegate: PresentationStepDelegate?

    var presentationStepViewController: PresentationStepViewController {
        return ShotsCollectionViewController()
    }

//    MARK: - PresentationStepViewControllerDelegate

    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController) {
        presentationStepDelegate?.presentationStepDidFinish(self)
    }
}
