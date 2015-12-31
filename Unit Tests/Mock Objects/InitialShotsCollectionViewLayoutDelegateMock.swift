//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby

@testable import Inbbbox

class InitialShotsCollectionViewLayoutDelegateMock: InitialShotsCollectionViewLayoutDelegate {

    let initialShotsCollectionViewDidFinishAnimationsMock = Mock<Void>()

    func initialShotsCollectionViewDidFinishAnimations() {
        initialShotsCollectionViewDidFinishAnimationsMock.record(())
    }
}
