//
//  PageableComponentSerializer.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class PageableComponentSerializer {
    
    class func nextPageableComponentWithSentQuery(query: Query, receivedHeader header: [String: AnyObject]) -> PageableComponent? {
        return stringComponentFromLinkHeader(header, withName: "next")?.url?.pageableComponentFromQuery(query)
    }
    
    class func previousPageableComponentWithSentQuery(query: Query, receivedHeader header: [String: AnyObject]) -> PageableComponent? {
        return stringComponentFromLinkHeader(header, withName: "prev")?.url?.pageableComponentFromQuery(query)
    }
}

private extension PageableComponentSerializer {
    
    class func stringComponentFromLinkHeader(header: [String: AnyObject], withName name: String) -> String? {
        let link = header["Link"] as? String
        let linkHeaderComponents = link?.componentsSeparatedByString(",")
        
        return linkHeaderComponents?.filter { $0.rangeOfString(name) != nil }.first
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
