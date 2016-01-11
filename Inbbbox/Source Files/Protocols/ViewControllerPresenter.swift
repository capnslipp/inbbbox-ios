//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ViewControllerPresenter {

    func presentViewController(viewControllerToPresent: UIViewController, animated animated: Bool, completion: (() -> Void)?)

    func dismissViewControllerAnimated(animated: Bool, completion: (() -> Void)?)
}
