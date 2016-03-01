//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit


class ShotsProvider {

    var apiShotsProvider = APIShotsProvider()
    var managedShotsProvider = ManagedShotsProvider()
    var userStorageClass = UserStorage.self

    func provideShots() -> Promise<[ShotType]?> {
        return apiShotsProvider.provideShots()
    }
    
    func provideMyLikedShots() -> Promise<[ShotType]?> {
        if userStorageClass.isUserSignedIn {
            return apiShotsProvider.provideMyLikedShots()
        }
        return managedShotsProvider.provideMyLikedShots()
    }

    func provideShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for user when user is not signed in")
        return apiShotsProvider.provideShotsForUser(user)
    }

    func provideLikedShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for user when user is not signed in")
        return apiShotsProvider.provideLikedShotsForUser(user)
    }

    func provideShotsForBucket(bucket: BucketType) -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for bucket bucket when user is not signed in")
        return apiShotsProvider.provideShotsForBucket(bucket)
    }

    func nextPage() -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for next page when user is not signed in")
        return apiShotsProvider.nextPage()
    }

    func previousPage() -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for previous page when user is not signed in")
        return apiShotsProvider.previousPage()
    }
}
