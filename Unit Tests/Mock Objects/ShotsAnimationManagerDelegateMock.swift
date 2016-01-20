//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Dobby

@testable import Inbbbox

class ShotsAnimationManagerDelegateMock: ShotsAnimationManagerDelegate {

    let collectionViewForAnimationManagerStub = Stub<(ShotsAnimationManager), UICollectionView?>()
    let itemsForAnimationManagerStub = Stub<ShotsAnimationManager, [AnyObject]>()

    func collectionViewForAnimationManager(animationManager: ShotsAnimationManager) -> UICollectionView? {
        return try! collectionViewForAnimationManagerStub.invoke(animationManager)
    }

    func itemsForAnimationManager(animationManager: ShotsAnimationManager) -> [AnyObject] {
        return try! itemsForAnimationManagerStub.invoke(animationManager)
    }
}
