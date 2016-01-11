//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class PresentationStepDelegateMock: PresentationStepDelegate {

    let presentationStepDidFinishStub = Stub<PresentationStep, Void>()

    func presentationStepDidFinish(presentationStep: PresentationStep) {
        try! presentationStepDidFinishStub.invoke(presentationStep)
    }
}
