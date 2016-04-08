//
//  OAuthAuthorizable.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol OAuthAuthorizable {
    
    var requestTokenURLString: String { get }
    var accessTokenURLString: String { get }
    
    var clientID: String { get }
    var clientSecret: String { get }
    var redirectURI: String { get }
    var scope: String { get }

    /// Provide `NSURLRequest` that should be used to receive token from API.
    /// 
    /// - returns: Request needed to get token.
    func requestTokenURLRequest() -> NSURLRequest
    
    /// Provide `NSURLRequest` that should be used to receive access token from API based on request token.
    ///
    /// - parameter token: Request token.
    ///
    /// - returns: Request needed to get access token.
    func accessTokenURLRequestWithRequestToken(token: String) -> NSURLRequest
    
    /// Check if URL is redirection URL.
    ///
    /// - parameter url: URL to check.
    ///
    /// - returns: `true` if given URL is redirection URL, `false` otherwise.
    func isRedirectionURL(url: NSURL?) -> Bool
    
    /// Check if URL is silent authentication URL.
    ///
    /// - parameter url: URL to check.
    ///
    /// - returns: `true` if given URL is silent authentication URL, `false` otherwise.
    func isSilentAuthenticationURL(url: NSURL?) -> Bool
}

extension OAuthAuthorizable {
    
    func requestTokenURLRequest() -> NSURLRequest {
      
        var parameters = Parameters(encoding: .URL)
        parameters["client_id"] = clientID
        parameters["redirect_uri"] = redirectURI
        parameters["scope"] = scope
        
        return requestForURLString(requestTokenURLString, HTTPMethod: .GET, parameters: parameters)
    }
    
    func accessTokenURLRequestWithRequestToken(token: String) -> NSURLRequest {
        
        var parameters = Parameters(encoding: .URL)
        parameters["client_id"] = clientID
        parameters["client_secret"] = clientSecret
        parameters["redirect_uri"] = redirectURI
        parameters["code"] = token
        
        return requestForURLString(accessTokenURLString, HTTPMethod: .POST, parameters: parameters)
    }
    
    func isRedirectionURL(url: NSURL?) -> Bool {
        
        if let url = url, host = url.host {
            return redirectURI == (url.scheme + "://" + host)
        }
        return false
    }
    
    func isSilentAuthenticationURL(url: NSURL?) -> Bool {
        return !(url != nil && url!.absoluteString.containsString("login?"))
    }
}

private extension OAuthAuthorizable {
    
    func requestForURLString(url: String, HTTPMethod: Method, parameters: Parameters) -> NSURLRequest {
        
        let components = NSURLComponents(string: url)
        components?.queryItems = parameters.queryItems
        
        let mutableRequest = NSMutableURLRequest(URL: components!.URL!)
        mutableRequest.HTTPMethod = HTTPMethod.rawValue
        
        return mutableRequest.copy() as! NSURLRequest
    }
}
