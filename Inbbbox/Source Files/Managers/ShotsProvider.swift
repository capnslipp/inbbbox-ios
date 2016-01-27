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

final class ShotsProvider {
    
    private enum ShotsProviderType {
        case General, User, Bucket
    }
    
    let configuration: ShotsProviderConfiguration
    private(set) var page: UInt
    private(set) var pagination: UInt
    
    private var type: ShotsProviderType?
    private var queryStartDate = NSDate()
    private var shouldRestoreInitialState = true

     /**
     Initializer with customizable parameters.
     
     - parameter page:          Number of page from which ShotsProvider should start to provide shots.
     - parameter pagination:    Pagination of request.
     - parameter configuration: Configuration for ShotsProvider.
     */
    init(page: UInt, pagination: UInt, configuration: ShotsProviderConfiguration = ShotsProviderConfiguration()) {
        self.page = page
        self.pagination = pagination
        self.configuration = configuration
    }
    
    /**
     Convenience initializer with default parameters.
     */
    convenience init() {
        self.init(page: 1, pagination: 30)
    }
    
    /**
     Provides shots with current configuration, paging and page.
     @discussion: queries uses underneath date to omit paging-page mismatch.
     If you want to reset page use restoreInitialState() method
     
     - returns: Promise which resolves with shots.
     */
    func provideShots() -> Promise<[Shot]> {
        
        secureCheckForType(.General)
        
        return Promise<[Shot]> { fulfill, reject in
            
            let requests = activeQueries.map { Request(query: $0) }

            firstly {
                when(requests.map { $0.resume() })
            }.then { response -> Void in
                
                let shots = response
                    .map { $0?.arrayValue.map { Shot.map($0) } }
                    .flatMap { $0 }
                    .flatMap { $0 }
                    .filter { !$0.animated } // animated after MVP
                    .unique
                    .sort { $0.createdAt.compare($1.createdAt) == .OrderedDescending }
            
                self.page++
                
                fulfill(shots)
                
            }.error(reject)
        }
    }
    
    /**
     Restores initial state of ShotsProvider.
     It means in next api call ShotsProvider will provide shots from the beginning.
     @discussion: Use whether inbbbox stream source will change. Otherwise strange behaviour may appear.
     */
    func restoreInitialState() {
        page = 1
        shouldRestoreInitialState = true
    }
    
    /**
     Provides shots for given user.
     
     - parameter user: User whose shots should be provided.
     
     - returns: Promise which resolves with shots. Optional.
     */
    func provideShotsForUser(user: User) -> Promise<[Shot]?> {
        
        secureCheckForType(.User)
        let query = ShotsQuery(user: user)
        
        return provideShotsWithQuery(query)
    }
    
    
    /**
     Provides shots for given bucket.
     
     - parameter bucket: Bucket which shots should be provided.
     
     - returns: Promise which resolves with shots. Optional.
     */
    func provideShotsForBucket(bucket: Bucket) -> Promise<[Shot]?> {
        
        secureCheckForType(.Bucket)
        let query = ShotsQuery(bucket: bucket)
        
        return provideShotsWithQuery(query)
    }
}

private extension ShotsProvider {
    
    var activeQueries: [ShotsQuery] {
        
        return configuration.sources.map {
            
            var query = ShotsQuery()
            
            query = queryByPagingConfiguration(query)
            query = configuration.queryByConfigurationForQuery(query, source: $0)
            
            return query
        }
    }
    
    func provideShotsWithQuery(var query: ShotsQuery) -> Promise<[Shot]?> {
        return Promise<[Shot]?> { fulfill, reject in
            
            query = queryByPagingConfiguration(query)
            let request = Request(query: query)
            
            firstly {
                request.resume()
            }.then { response -> Void in
                
                let shots = response
                    .map { $0.arrayValue.map { Shot.map($0) } }
                
                self.page++
                
                fulfill(shots)
                
            }.error(reject)
        }
    }
    
    func secureCheckForType(providerType: ShotsProviderType) {
        
        if let type = type where type != providerType && !shouldRestoreInitialState {
            fatalError("Initialize new instance of ShotsProvider or restore initial state of current one for providing shots with different type.")
        }
        type = providerType
        
        if shouldRestoreInitialState {
            shouldRestoreInitialState = false
            queryStartDate = NSDate()
        }
    }
    
    func queryByPagingConfiguration(var query: ShotsQuery) -> ShotsQuery {
        
        query.date = queryStartDate
        query.parameters["page"] = page
        query.parameters["per_page"] = pagination
        
        return query
    }
}

private extension Array {
    
    var unique: [Shot] {
     
        var array = [Shot]()
        
        forEach {
            if let shot = $0 as? Shot where !array.contains(shot) {
                array.append(shot)
            }
        }
        
        return array
    }
}
