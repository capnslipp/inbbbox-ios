//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class UserStorageMock: UserStorage {

    static let currentUserStub = Stub<Void, User?>()

    override class var currentUser: User? {
        return try! currentUserStub.invoke()
    }
}
