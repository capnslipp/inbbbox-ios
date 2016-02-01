//
//  PageableComponent.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct PageableComponent {
    
    let path: String
    let queryItems: [NSURLQueryItem]?
    
    init(path: String, query: String?) {
        self.path = path
        self.queryItems = query?.queryItems
    }
}

private extension String {
    
    var queryItems: [NSURLQueryItem]? {
        
        return componentsSeparatedByString("&").map { component -> NSURLQueryItem in
            let components = component.componentsSeparatedByString("=")
            return NSURLQueryItem(name: components[0], value: components[1])
        }
    }
}

extension PageableComponent: CustomDebugStringConvertible {
    
    var debugDescription: String {
        
        let items = queryItems?
            .map { "\($0.name)=\($0.value)" }
            .reduce("", combine: { $0 == "" ? $1 : $0 + "&" + $1 })
        
        return path + "?" + (items ?? "")
    }
}
