//
//  ShotsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/**
Class for providing shots of various source type.
*/

class ShotsProvider: PageableProvider {

    /// Used only when using provideShots() method.
    var configuration = ShotsProviderConfiguration()
    let page: UInt
    let pagination: UInt

    private var currentSourceType: SourceType?
    private enum SourceType {
        case General, Bucket, User, Liked
    }
    
     /**
     Initializer with customizable parameters.
     
     - parameter page:          Number of page from which ShotsProvider should start to provide shots.
     - parameter pagination:    Pagination of request.
     */
    init(page: UInt, pagination: UInt) {
        self.page = page
        self.pagination = pagination
    }
    
    /**
     Convenience initializer with default parameters.
     */
    convenience override init() {
        self.init(page: 1, pagination: 30)
    }
    
    /**
     Provides shots with current configuration, pagination and page.
     
     - returns: Promise which resolves with shots or nil.
     */
    func provideShots() -> Promise<[Shot]?> {
        resetAnUseSourceType(.General)
        return provideShotsWithQueries(activeQueries)
    }
    
    /**
     Provides shots for given user.
     
     - parameter user: User whose shots should be provided.
     
     - returns: Promise which resolves with shots or nil.
     */
    func provideShotsForUser(user: User) -> Promise<[Shot]?> {
        resetAnUseSourceType(.User)
        
        let query = ShotsQuery(type: .UserShots(user))
        return provideShotsWithQueries([query])
    }
    
    /**
     Provides liked shots for given user.
     
     - parameter user: User whose liked shots should be provided.
     
     - returns: Promise which resolves with shots or nil.
     */
    func provideLikedShotsForUser(user: User) -> Promise<[Shot]?> {
        resetAnUseSourceType(.Liked)
        
        let query = ShotsQuery(type: .UserLikedShots(user))
        return provideShotsWithQueries([query], serializationKey: "shot")
    }
    
    /**
     Provides shots for given bucket.
     
     - parameter bucket: Bucket which shots should be provided.
     
     - returns: Promise which resolves with shots or nil.
     */
    func provideShotsForBucket(bucket: Bucket) -> Promise<[Shot]?> {
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
    func nextPage() -> Promise<[Shot]?> {
        return fetchPage(nextPageFor(Shot))
    }
    
    /**
     Provides previous page of shots.
     
     - Warning: You have to use any of provideShots... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with shots or nil.
     */
    func previousPage() -> Promise<[Shot]?> {
        return fetchPage(previousPageFor(Shot))
    }
}

private extension ShotsProvider {
    
    var activeQueries: [ShotsQuery] {
        return configuration.sources.map {
            configuration.queryByConfigurationForQuery(ShotsQuery(type: .List), source: $0)
        }
    }
    
    func provideShotsWithQueries(let shotQueries: [ShotsQuery], serializationKey key: String? = nil) -> Promise<[Shot]?> {
        return Promise<[Shot]?> { fulfill, reject in
            
            let queries = shotQueries.map { queryByPagingConfiguration($0) } as [Query]
            
            firstly {
                firstPageForQueries(queries, withSerializationKey: key)
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }
    
    func queryByPagingConfiguration(var query: ShotsQuery) -> ShotsQuery {
        
        query.date = NSDate()
        query.parameters["page"] = page
        query.parameters["per_page"] = pagination
        
        return query
    }

    func resetAnUseSourceType(type: SourceType) {
        currentSourceType = type
        resetPages()
    }
    
    func fetchPage(promise: Promise<[Shot]?>) -> Promise<[Shot]?> {
        return Promise<[Shot]?> { fulfill, reject in
            
            if currentSourceType == nil {
                throw PageableProviderError.PageableBehaviourUndefined
            }
            
            firstly {
                promise
            }.then {
                self.serialize($0, fulfill)
            }.error(reject)
        }
    }
    
    func serialize(shots: [Shot]?, _ fulfill: ([Shot]?) -> Void) {
        let result = shots?
            .filter { !$0.animated } // animated after MVP
            .unique
            .sort { $0.createdAt.compare($1.createdAt) == .OrderedDescending }
        
        fulfill(result)
    }
}
