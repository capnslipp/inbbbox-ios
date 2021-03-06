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
        return apiShotsProvider.provideShotsForUser(user)
    }

    func provideLikedShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        assert(userStorageClass.isUserSignedIn, "Cannot provide shots for user when user is not signed in")
        return Promise<[ShotType]?> { fulfill, reject in
            firstly {
                apiShotsProvider.provideLikedShotsForUser(user)
            }.then { shots -> Void in
                let shotsSorted = shots?.sort {
                    return $0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedAscending
                }
                fulfill(shotsSorted)
            }.error(reject)
        }

    }

    func provideShotsForBucket(bucket: BucketType) -> Promise<[ShotType]?> {
        if userStorageClass.isUserSignedIn {
            return apiShotsProvider.provideShotsForBucket(bucket)
        }
        return managedShotsProvider.provideShotsForBucket(bucket)
    }

    func nextPage() -> Promise<[ShotType]?> {
        return apiShotsProvider.nextPage()
    }

    func previousPage() -> Promise<[ShotType]?> {
        return apiShotsProvider.previousPage()
    }
}
