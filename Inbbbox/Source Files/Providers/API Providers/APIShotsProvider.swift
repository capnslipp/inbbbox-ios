//
//  APIShotsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/// Provides interface for dribbble shots API
class APIShotsProvider: PageableProvider {

    /// Used only when using provideShots() method.
    var configuration = APIShotsProviderConfiguration()

    private var currentSourceType: SourceType?
    private enum SourceType {
        case General, Bucket, User, Liked
    }

    /**
     Provides shots with current configuration, pagination and page.

     - returns: Promise which resolves with shots or nil.
     */
    func provideShots() -> Promise<[ShotType]?> {
        resetAnUseSourceType(.General)
        return provideShotsWithQueries(activeQueries)
    }

    /**
     Provides shots for given user.

     - parameter user: User whose shots should be provided.

     - returns: Promise which resolves with shots or nil.
     */
    func provideShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        resetAnUseSourceType(.User)

        let query = ShotsQuery(type: .UserShots(user))
        return provideShotsWithQueries([query])
    }

    /**
     Provides liked shots for given user.

     - parameter user: User whose liked shots should be provided.

     - returns: Promise which resolves with shots or nil.
     */
    func provideLikedShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        resetAnUseSourceType(.Liked)

        let query = ShotsQuery(type: .UserLikedShots(user))
        return provideShotsWithQueries([query], serializationKey: "shot")
    }

    /**
     Provides shots for given bucket.

     - parameter bucket: Bucket which shots should be provided.

     - returns: Promise which resolves with shots or nil.
     */
    func provideShotsForBucket(bucket: BucketType) -> Promise<[ShotType]?> {
        resetAnUseSourceType(.Bucket)

        let query = ShotsQuery(type: .BucketShots(bucket))
        return provideShotsWithQueries([query])
    }

    /**
     Provides next page of shots.

     - Warning: You have to use any of provideShots... method first to be able to use this method.
     Otherwise an exception will appear.

     - returns: Promise which resolves with shots or nil.
     */
    func nextPage() -> Promise<[ShotType]?> {
        return fetchPage(nextPageFor(Shot))
    }

    /**
     Provides previous page of shots.

     - Warning: You have to use any of provideShots... method first to be able to use this method.
     Otherwise an exception will appear.

     - returns: Promise which resolves with shots or nil.
     */
    func previousPage() -> Promise<[ShotType]?> {
        return fetchPage(previousPageFor(Shot))
    }
}

private extension APIShotsProvider {

    var activeQueries: [Query] {
        return configuration.sources.map {
            configuration.queryByConfigurationForQuery(ShotsQuery(type: .List), source: $0)
        }
    }

    func provideShotsWithQueries(queries: [Query], serializationKey key: String? = nil) -> Promise<[ShotType]?> {
        return Promise<[ShotType]?> { fulfill, reject in

            firstly {
                firstPageForQueries(queries, withSerializationKey: key)
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }

    func resetAnUseSourceType(type: SourceType) {
        currentSourceType = type
        resetPages()
    }

    func fetchPage(promise: Promise<[Shot]?>) -> Promise<[ShotType]?> {
        return Promise<[ShotType]?> { fulfill, reject in

            if currentSourceType == nil {
                throw PageableProviderError.BehaviourUndefined
            }

            firstly {
                promise
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }

    func serialize(shots: [Shot]?, _ fulfill: [ShotType]? -> Void) {
        let result = shots?
            .unique
            .sort { $0.createdAt.compare($1.createdAt) == .OrderedDescending }
        fulfill(result.flatMap{ $0.map { $0 as ShotType } })
    }
}
