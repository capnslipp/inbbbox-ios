//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Dobby

@testable import Inbbbox

class InitialShotsAnimationManagerMock: InitialShotsAnimationManager {

    let startAnimationWithCompletionStub = Stub<(Void -> Void)?, Void>()

    override func startAnimationWithCompletion(completion: (Void -> Void)?) {
        try! startAnimationWithCompletionStub.invoke(completion)
    }
}
