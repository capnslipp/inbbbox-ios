//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit


class ShotsProvider {

    let apiShotsProvider = APIShotsProvider()
    let managedShotsProvider = ManagedShotsProvider()

    func provideShots() -> Promise<[ShotType]?> {
        return apiShotsProvider.provideShots()
    }

    func provideShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        assert(UserStorage.userIsSignedIn, "Cannot provide shots for user when user is not signed in")
        return apiShotsProvider.provideShotsForUser(user)
    }

    func provideLikedShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        if UserStorage.userIsSignedIn {
            return apiShotsProvider.provideLikedShotsForUser(user)
        }
        return managedShotsProvider.provideLikedShotsForUser(user)
    }

    func provideShotsForBucket(bucket: BucketType) -> Promise<[ShotType]?> {
        assert(UserStorage.userIsSignedIn, "Cannot provide shots for bucket bucket when user is not signed in")
        return apiShotsProvider.provideShotsForBucket(bucket)
    }

    func nextPage() -> Promise<[ShotType]?> {
        assert(UserStorage.userIsSignedIn, "Cannot provide shots for next page when user is not signed in")
        return apiShotsProvider.nextPage()
    }

    func previousPage() -> Promise<[ShotType]?> {
        assert(UserStorage.userIsSignedIn, "Cannot provide shots for previous page when user is not signed in")
        return apiShotsProvider.previousPage()
    }
}
