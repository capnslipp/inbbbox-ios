//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DefaultViewControllerPresenter: ViewControllerPresenter {

    private(set) weak var presentingViewController: UIViewController?

    init(presentingViewController presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

//    MARK: - ViewControllerPresenter

    func presentViewController(viewController: UIViewController, animated animated: Bool, completion: (() -> Void)?) {
        presentingViewController?.presentViewController(viewController, animated: animated, completion: completion)
    }

    func dismissViewControllerAnimated(animated: Bool, completion: (() -> Void)?) {
        presentingViewController?.dismissViewControllerAnimated(animated, completion: completion)
    }
}
