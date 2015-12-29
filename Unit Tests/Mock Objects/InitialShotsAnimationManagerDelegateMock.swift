//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Dobby

@testable import Inbbbox

class InitialShotsAnimationManagerDelegateMock: InitialShotsAnimationManagerDelegate {

    let collectionViewForAnimationManagerStub = Stub<(InitialShotsAnimationManager), UICollectionView?>()
    let itemsForAnimationManagerStub = Stub<InitialShotsAnimationManager, [AnyObject]>()

    func collectionViewForAnimationManager(animationManager: InitialShotsAnimationManager) -> UICollectionView? {
        return try! collectionViewForAnimationManagerStub.invoke(animationManager)
    }

    func itemsForAnimationManager(animationManager: InitialShotsAnimationManager) -> [AnyObject] {
        return try! itemsForAnimationManagerStub.invoke(animationManager)
    }
}
