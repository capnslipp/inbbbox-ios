//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ClosureExecutor {

    func executeClosureOnMainThread(delay delay: Double, closure: Void -> Void) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            closure()
        })
    }
}
