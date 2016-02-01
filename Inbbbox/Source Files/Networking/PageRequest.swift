//
//  PageRequest.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

typealias PageResponse = (json: JSON?, pages: (next: PageableComponent?, previous: PageableComponent?))

struct PageRequest: Requestable, Responsable {
    let query: Query
    
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func resume() -> Promise<PageResponse> {
        return Promise<PageResponse> { fulfill, reject in
            
            let dataTask = session.dataTaskWithRequest(foundationRequest) { data, response, error in
                
                if let error = error {
                    reject(error); return
                }

                firstly {
                    self.responseWithData(data, response: response)
                    
                }.then { response -> Void in
                    
                    let pageableComponents = self.pageableComponentsFromHeader(response.header)
                    fulfill((
                        json: response.json,
                        pages: (
                            next: pageableComponents.next,
                            previous: pageableComponents.previous)
                    ))
                    
                }.error(reject)
            }
            
            dataTask.resume()
        }
    }
}

private extension PageRequest {
    
    func pageableComponentsFromHeader(header: [String: AnyObject]?) -> (next: PageableComponent?, previous: PageableComponent?) {
        
        let link = header?["Link"] as? String
        let linkHeaderComponents = link?.componentsSeparatedByString(",")
        
        var next: PageableComponent?
        var previous: PageableComponent?
        
        linkHeaderComponents?.forEach {
            if $0.rangeOfString("next") != nil {
                next = $0.url?.pageableComponentFromQuery(query)
                
            } else if $0.rangeOfString("prev") != nil {
                previous = $0.url?.pageableComponentFromQuery(query)
            }
        }
        
        return (next: next, previous: previous)
    }
}

private extension String {
    
    var url: NSURL? {
        
        guard let leftBracket = rangeOfString("<"), rightBracket = rangeOfString(">") else {
            return nil
        }
        
        let range = Range<String.Index>(
            start: leftBracket.startIndex.advancedBy(1),
            end: rightBracket.endIndex.advancedBy(-1)
        )
        let urlString = substringWithRange(range)
        
        return  NSURL(string: urlString)
    }
}

private extension NSURL {
    
    func pageableComponentFromQuery(requestQuery: Query) -> PageableComponent? {
        
        guard var path = path else {
            return nil
        }
        
        if let substringEndIndex = path.rangeOfString(requestQuery.service.version)?.endIndex {
            path = path.substringFromIndex(substringEndIndex)
        }
        
        return PageableComponent(path: path, query: query)
    }
}
