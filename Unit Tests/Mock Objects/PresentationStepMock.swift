//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class PresentationStepMock: PresentationStep {

    let presentationStepViewControllerStub = Stub<Void, PresentationStepViewController>()

    //    MARK: - PresentationStep

    weak var presentationStepDelegate: PresentationStepDelegate?

    var presentationStepViewController: PresentationStepViewController {
        return try! presentationStepViewControllerStub.invoke()
    }

}
