//
//  ShotsProvider.swift
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

class ShotsProvider: Pageable {

    /// Used only when using provideShots() method.
    var configuration = ShotsProviderConfiguration()
    let page: UInt
    let pagination: UInt
    
    // Pageable protocol conformance.
    var nextPageableComponents = [PageableComponent]()
    var previousPageableComponents = [PageableComponent]()

    private var currentSourceType: SourceType?
    private enum SourceType {
        case General, Bucket, User
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
    convenience init() {
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
        
        let query = ShotsQuery(user: user)
        return provideShotsWithQueries([query])
    }
    
    /**
     Provides shots for given bucket.
     
     - parameter bucket: Bucket which shots should be provided.
     
     - returns: Promise which resolves with shots or nil.
     */
    func provideShotsForBucket(bucket: Bucket) -> Promise<[Shot]?> {
        resetAnUseSourceType(.Bucket)
        
        let query = ShotsQuery(bucket: bucket)
        return provideShotsWithQueries([query])
    }
    
    /**
     Provides next page of shots.
     
     **Important** You have to use any of provideShots... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with shots or nil.
     */
    func nextPage() -> Promise<[Shot]?> {
        
        checkCorrectnessOfUsage()
        
        return Promise<[Shot]?> { fulfill, reject in
            
            firstly {
                nextPageFor(Shot)
            }.then { response -> Void in

                let result = self.currentSourceType?.serialize(response)
                fulfill(result)
                
            }.error(reject)
        }
    }
    
    /**
     Provides previous page of shots.
     
     **Important** You have to use any of provideShots... method first to be able to use this method.
     Otherwise an exception will appear.
     
     - returns: Promise which resolves with shots or nil.
     */
    func previousPage() -> Promise<[Shot]?> {
        
        checkCorrectnessOfUsage()
        
        return Promise<[Shot]?> { fulfill, reject in
            
            firstly {
                previousPageFor(Shot)
            }.then { response -> Void in
                
                let result = self.currentSourceType?.serialize(response)
                fulfill(result)
                
            }.error(reject)
        }
    }
}

private extension ShotsProvider {
    
    var activeQueries: [ShotsQuery] {
        return configuration.sources.map {
            configuration.queryByConfigurationForQuery(ShotsQuery(), source: $0)
        }
    }
    
    func provideShotsWithQueries(let shotQueries: [ShotsQuery]) -> Promise<[Shot]?> {
        return Promise<[Shot]?> { fulfill, reject in
            
            let queries = shotQueries.map { queryByPagingConfiguration($0) } as [Query]
            
            firstly {
                firstPageFor(Shot.self, withQueries: queries)
            
            }.then { response -> Void in
                
                let result = self.currentSourceType?.serialize(response)
                fulfill(result)
                
            }.error(reject)
        }
    }
    
    func queryByPagingConfiguration(var query: ShotsQuery) -> ShotsQuery {
        
        query.date = NSDate()
        query.parameters["page"] = page
        query.parameters["per_page"] = pagination
        
        return query
    }
    
    func checkCorrectnessOfUsage() {
        if currentSourceType == nil {
            fatalError("You cannot ask for next or previous page without using any of provideShots.. method first.")
        }
    }
    
    func resetAnUseSourceType(type: SourceType) {
        currentSourceType = type
        nextPageableComponents = []
        previousPageableComponents = []
    }
}

private extension ShotsProvider.SourceType {
    
    func serialize(shots: [Shot]?) -> [Shot]? {
        
        guard self == General else {
            return shots
        }
        
        return shots?
            .filter { !$0.animated } // animated after MVP
            .unique
            .sort { $0.createdAt.compare($1.createdAt) == .OrderedDescending }
    }
}
