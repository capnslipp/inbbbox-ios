//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class ClosureExecutorMock: ClosureExecutor {

    let executeClosureOnMainThreadStub = Stub<(Double, Void -> Void), Void>()

    override func executeClosureOnMainThread(delay delay: Double, closure: Void -> Void) {
        try! executeClosureOnMainThreadStub.invoke(delay, closure)
    }
}
