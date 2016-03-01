//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class UserStorageMock: UserStorage {

    static let userIsSignedInStub = Stub<Void, Bool>()

    override class var isUserSignedIn: Bool {
        return try! userIsSignedInStub.invoke()
    }
}
