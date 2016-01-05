//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

class AsyncWrapper {

    func main(after after: Double? = nil, block: dispatch_block_t) -> AsyncWrapper {
        Async.main(after: after, block: block)
        return self
    }
}
