//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class PresentationContainerViewController: UIViewController, PresentationStepDelegate {

    var presentationSteps = [PresentationStep]()
    var viewControllerPresenter: ViewControllerPresenter?

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.viewControllerPresenter = DefaultViewControllerPresenter(presentingViewController: self)
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let firstPresentationStep = presentationSteps.first else {
            return
        }

        presentStep(firstPresentationStep)
    }

//    MARK: - PresentationStepDelegate

    func presentationStepDidFinish(presentationStep: PresentationStep) {
        removeChildPresentationStepViewController(presentationStep.presentationStepViewController)

        guard let presentationStepIndex = presentationSteps.indexOf({ $0 === presentationStep }) else {
            return
        }
        let nextPresentationStepIndex = presentationStepIndex + 1

        let nextPresentationStep = presentationSteps[nextPresentationStepIndex]
        presentStep(nextPresentationStep)
    }

//    MARK: - Helpers

    private func presentStep(presentationStep: PresentationStep) {
        let presentationStepViewController = presentationStep.presentationStepViewController
        if presentationSteps.last === presentationStep {
            self.viewControllerPresenter?.presentViewController(presentationStepViewController.viewController, animated: false, completion: nil)
        } else {
            presentationStep.presentationStepDelegate = self
            addChildPresentationStepViewController(presentationStepViewController)
        }
    }

    private func addChildPresentationStepViewController(presentationStepViewController: PresentationStepViewController) {
        let viewController = presentationStepViewController.viewController
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.autoPinEdgesToSuperviewEdges()
        viewController.didMoveToParentViewController(self)
    }

    private func removeChildPresentationStepViewController(presentationStepViewController: PresentationStepViewController) {
        let viewController = presentationStepViewController.viewController
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
