//
//  PageableProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

enum PageableProviderError: ErrorType {
    case BehaviourUndefined
    case DidReachLastPage
    case DidReachFirstPage
}

class PageableProvider: Verifiable {
    
    private(set) var page = UInt(1)
    private(set) var pagination = UInt(30)
  
    private var nextPageableComponents: [PageableComponent]?
    private var previousPageableComponents: [PageableComponent]?
    
    private var serializationKey: String?
    private var didDefineProviderMethodBefore = false
    
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
     Default initializer provided for simplify initalization with default parameters.
     Required by subclasses.
     */
    init() {}
    
    func firstPageForQueries<T: Mappable>(queries: [Query], withSerializationKey key: String?) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, reject in
            
            resetPages()
            serializationKey = key
            didDefineProviderMethodBefore = true
            
            let mappedQueries = queries.map { queryByPagingConfiguration($0) }
            
            pageWithQueries(mappedQueries).then(fulfill).error(reject)
        }
    }
    
    func nextPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, reject in
            
            if !didDefineProviderMethodBefore {
                throw PageableProviderError.BehaviourUndefined
            }
            
            guard let nextPageableComponents = nextPageableComponents else {
                throw PageableProviderError.DidReachLastPage
            }
            
            let queries = nextPageableComponents.map {
                PageableQuery(path: $0.path, queryItems: $0.queryItems)
            } as [Query]
            
            pageWithQueries(queries).then(fulfill).error(reject)
        }
    }
    
    func previousPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, reject in
            
            if !didDefineProviderMethodBefore {
                throw PageableProviderError.BehaviourUndefined
            }
            
            guard let previousPageableComponents = previousPageableComponents else {
                throw PageableProviderError.DidReachFirstPage
            }
            
            let queries = previousPageableComponents.map {
                PageableQuery(path: $0.path, queryItems: $0.queryItems)
            } as [Query]
            
            pageWithQueries(queries).then(fulfill).error(reject)
        }
    }
    
    func resetPages() {
        serializationKey = nil
        nextPageableComponents = nil
        previousPageableComponents = nil
    }
}

private extension PageableProvider {
    
    func pageWithQueries<T: Mappable>(queries: [Query]) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, reject in
            
            let requests = queries.map { PageRequest(query: $0) }
            
            firstly {
                when(requests.map { $0.resume() })
            }.then { responses -> Void in
                
                self.nextPageableComponents = {
                    let next = responses.filter { $0.pages.next != nil }.map { $0.pages.next! }
                    
                    return next.count > 0 ? next : nil
                }()
                self.previousPageableComponents = {
                    let previous = responses.filter { $0.pages.previous != nil }.map { $0.pages.previous! }
                    
                    return previous.count > 0 ? previous : nil
                }()
                
                let result = responses
                    .map { $0.json?.arrayValue.map { T.map( self.serializationKey != nil ? $0[self.serializationKey!] : $0 ) } }
                    .flatMap { $0 }
                    .flatMap { $0 }
                
                fulfill(result)
                
            }.error(reject)
        }
    }
    
    func queryByPagingConfiguration(query: Query) -> Query {
        var resultQuery = query
        resultQuery.parameters["page"] = page
        resultQuery.parameters["per_page"] = pagination
        
        return resultQuery
    }
}
