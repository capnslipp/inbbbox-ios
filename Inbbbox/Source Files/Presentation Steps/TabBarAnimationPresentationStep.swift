//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TabBarAnimationPresentationStep: PresentationStep, PresentationStepViewControllerDelegate {

    //    MARK: - PresentationStep

    weak var presentationStepDelegate: PresentationStepDelegate?

    var presentationStepViewController: PresentationStepViewController {
        let presentationStepViewController = TabBarAnimationViewController()
        presentationStepViewController.presentationStepViewControllerDelegate = self
        return presentationStepViewController
    }

//    MARK: - PresentationStepViewControllerDelegate

    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController) {
        presentationStepDelegate?.presentationStepDidFinish(self)
    }
}
