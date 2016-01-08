//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class PresentationStepViewControllerMock: PresentationStepViewController {

    let viewControllerStub = Stub<Void, UIViewController>()

//    MARK: - PresentationStepViewController

    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate?
    var viewController: UIViewController {
        return try! viewControllerStub.invoke()
    }
}
