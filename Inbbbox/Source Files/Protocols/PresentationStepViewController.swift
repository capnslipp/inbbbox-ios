//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol PresentationStepViewControllerDelegate: class {
    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController)
}

protocol PresentationStepViewController: class {
    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate? { get set }
    var viewController: UIViewController { get }
}
