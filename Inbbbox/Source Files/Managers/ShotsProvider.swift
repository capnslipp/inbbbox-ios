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

class ShotsProvider {
    
    let configuration: ShotsProviderConfiguration
    private(set) var page: UInt
    private(set) var pagination: UInt
    
    private var queryStartDate = NSDate()
    private var shouldRestartDate = true

     /**
     Initializer with customizable parameters.
     
     - parameter page:          Number of page from which ShotsProvider should start to provide shots.
     - parameter pagination:    Pagination of request.
     - parameter configuration: Configuration for ShotsProvider.
     */
    init(page: UInt, pagination: UInt, configuration: ShotsProviderConfiguration) {
        self.page = page
        self.pagination = pagination
        self.configuration = configuration
    }
    
    /**
     Convenience initializer with default parameters.
     */
    convenience init() {
        self.init(page: 1, pagination:30, configuration: ShotsProviderConfiguration())
    }
    
    /**
     Provides shots with current configuration, paging and page.
     @discussion: queries uses underneath date to omit paging-page mismatch.
     If you want to reset page use restoreInitialState() method
     
     - returns: Promise which resolves with shots.
     */
    func provideShots() -> Promise<[Shot]> {
        
        if shouldRestartDate {
            shouldRestartDate = false
            queryStartDate = NSDate()
        }
        
        return Promise<[Shot]> { fulfill, reject in
            
            let requests = activeQueries.map { Request(query: $0) }

            firstly {
                when(requests.map { $0.resume() })
            }.then { responses -> Void in
                
                let shots = responses
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
     It means in next api call ShotsProvider will provide shots from beggining.
     @discussion: Use whether inbbbox stream source will change. Otherwise strange behaviour may appear.
     */
    func restoreInitialState() {
        page = 1
        shouldRestartDate = true
    }
}

private extension ShotsProvider {
    
    var activeQueries: [ShotsQuery] {
        
        return configuration.sources.map {
            
            var query = ShotsQuery()
            query.date = queryStartDate
            query.parameters["page"] = page
            query.parameters["per_page"] = pagination
            
            if $0 == .Following {
                query.followingUsersShotsQuery = true
            }
            
            configuration.configureQuery(&query, forSource: $0)
            
            return query
        }
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
