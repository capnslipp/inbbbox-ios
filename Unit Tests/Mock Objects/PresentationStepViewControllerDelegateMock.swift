//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class PresentationStepViewControllerDelegateMock: PresentationStepViewControllerDelegate {

    let presentationStepViewControllerDidFinishPresentingStub = Stub<PresentationStepViewController, Void>()

    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController) {
        try! presentationStepViewControllerDidFinishPresentingStub.invoke(presentationStepViewController)
    }
}
