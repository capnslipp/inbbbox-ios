//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class ShotsLocalStorageMock: ShotsLocalStorage {

    let likeStub = Stub<String, Void>()

    override func like(shotID shotID: String) {
        try! likeStub.invoke(shotID)
    }
}
