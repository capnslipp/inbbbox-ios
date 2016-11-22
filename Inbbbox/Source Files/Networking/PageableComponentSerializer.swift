//
//  PageableComponentSerializer.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class PageableComponentSerializer {

    /// Provides next page component for given query.
    ///
    /// - parameter query:          Query which the next page component should be created for.
    /// - parameter receivedHeader: Received response's header.
    ///
    /// - returns: Component for next page.
    class func nextPageableComponentWithSentQuery(_ query: Query,
                                                  receivedHeader header: [String: AnyObject]) -> PageableComponent? {
        return stringComponentFromLinkHeader(header, withName: "next")?.url?.pageableComponentFromQuery(query)
    }

    /// Provides previous page component for given query.
    ///
    /// - parameter query:          Query which the previous page component should be created for.
    /// - parameter receivedHeader: Received response's header.
    ///
    /// - returns: Component for previous page.
    class func previousPageableComponentWithSentQuery(_ query: Query, receivedHeader header: [String: AnyObject])
                    -> PageableComponent? {
        return stringComponentFromLinkHeader(header, withName: "prev")?.url?.pageableComponentFromQuery(query)
    }
}

private extension PageableComponentSerializer {

    class func stringComponentFromLinkHeader(_ header: [String: AnyObject], withName name: String) -> String? {
        let link = header["Link"] as? String
        let linkHeaderComponents = link?.components(separatedBy: ",")

        return linkHeaderComponents?.filter { $0.range(of: name) != nil }.first
    }
}

private extension String {

    var url: URL? {

        guard let leftBracket = self.range(of: "<"), let rightBracket = self.range(of: ">") else {
            return nil
        }

        let range: Range<String.Index> = leftBracket.startIndex.advancedBy(1) ..< rightBracket.endIndex.advancedBy(-1)
        let urlString = substringWithRange(range)

        return  URL(string: urlString)
    }
}

private extension URL {

    func pageableComponentFromQuery(_ requestQuery: Query) -> PageableComponent? {

        guard var path = path else {
            return nil
        }

        if let substringEndIndex = path.range(of: requestQuery.service.version)?.upperBound {
            path = path.substring(from: substringEndIndex)
        }

        return PageableComponent(path: path, query: query)
    }
}
