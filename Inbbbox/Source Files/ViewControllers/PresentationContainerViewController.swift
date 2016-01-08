//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class PresentationContainerViewController: UIViewController, PresentationStepDelegate {

    var presentationSteps = [PresentationStep]()

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let firstPresentationStep = presentationSteps.first else {
            return
        }

        firstPresentationStep.presentationStepDelegate = self
        addChildPresentationStepViewController(firstPresentationStep.presentationStepViewController)
    }

//    MARK: - PresentationStepDelegate

    func presentationStepDidFinish(presentationStep: PresentationStep) {
        removeChildPresentationStepViewController(presentationStep.presentationStepViewController)

        guard let presentationStepIndex = presentationSteps.indexOf({ $0 === presentationStep }) else {
            return
        }
        let nextPresentationStepIndex = presentationStepIndex + 1
        if presentationSteps.count == nextPresentationStepIndex {
            return
        }

        let nextPresentationStep = presentationSteps[nextPresentationStepIndex]
        nextPresentationStep.presentationStepDelegate = self
        addChildPresentationStepViewController(nextPresentationStep.presentationStepViewController)
    }

//    MARK: - Helpers

    private func removeChildPresentationStepViewController(presentationStepViewController: PresentationStepViewController) {
        let viewController = presentationStepViewController.viewController
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    private func addChildPresentationStepViewController(presentationStepViewController: PresentationStepViewController) {
        let viewController = presentationStepViewController.viewController
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}
