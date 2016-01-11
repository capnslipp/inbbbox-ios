//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol PresentationStepViewControllerDelegate: class {
    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController)
}

protocol PresentationStepViewController: class {
    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate? { get set }

//    This property should return new view controller, without storing it in property
//    Steps are kept in array so we don't want to hold array of view controllers, because it would not be memory efficient
    var viewController: UIViewController { get }
}
