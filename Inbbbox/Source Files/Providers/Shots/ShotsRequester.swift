//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class ShotsRequester {

    let apiShotsRequester = APIShotsRequester()
    let managedShotsRequester = ManagedShotsRequester()

    func likeShot(shot: ShotType) -> Promise<Void> {
        if UserStorage.userIsSignedIn {
            return apiShotsRequester.likeShot(shot)
        }
        return managedShotsRequester.likeShot(shot)
    }

    func unlikeShot(shot: ShotType) -> Promise<Void> {
        if UserStorage.userIsSignedIn {
            return apiShotsRequester.unlikeShot(shot)
        }
        return managedShotsRequester.unlikeShot(shot)
    }

    func isShotLikedByMe(shot: ShotType) -> Promise<Bool> {
        if UserStorage.userIsSignedIn {
            return apiShotsRequester.isShotLikedByMe(shot)
        }
        return managedShotsRequester.isShotLikedByMe(shot)
    }
}
