//
//  OAuthViewModel.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import WebKit.WKNavigationDelegate

final class OAuthViewModel: NSObject {
    
    let service: OAuthAuthorizable
    private(set) var currentResolvers: (fulfill: String -> Void, reject: ErrorType -> Void)?
    
    var loadRequestReverseClosure: (NSURLRequest -> Void)?
    
    init(oAuthAuthorizableService: OAuthAuthorizable) {
        service = oAuthAuthorizableService
        super.init()
    }
    
    func actionPolicyForRequest(request: NSURLRequest) -> WKNavigationActionPolicy {
        
        if service.isRedirectionURL(request.URL) {
            currentResolvers?.fulfill(request.URL!.query!)
            return .Cancel
        }
        
        return .Allow
    }
    
    func startAuthentication() -> Promise<String> {
        return Promise { fulfill, reject in
            
            firstly {
                gainRequestToken()
            }.then { query in
                self.decodeRequestTokenFromQuery(query)
            }.then { requestToken in
                self.gainAccessTokenWithReqestToken(requestToken)
            }.then { accessToken -> Void in
                fulfill(accessToken)
            }.error { error in
                reject(error)
            }
        }
    }
}

private extension OAuthViewModel {
    
    func gainRequestToken() -> Promise<String> {
        return Promise<String> { fulfill, reject in
            
            self.currentResolvers = (fulfill, reject)
            
            let urlRequest = service.requestTokenURLRequest()
            loadRequestReverseClosure?(urlRequest)
        }
    }
    
    func gainAccessTokenWithReqestToken(token: String) -> Promise<String> {
        return Promise<String> { fulfill, reject in
            
            self.currentResolvers = (fulfill, reject)
            
            let request = service.accessTokenURLRequestWithRequestToken(token)
            
            firstly {
                NSURLSession.POST(request.URL!.absoluteString)
            }.then { data -> Void in
                
                guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else {
                    throw AuthenticatorError.DataDecodingFailure
                }
                
                guard let accessToken = json["access_token"] as? String else {
                    throw AuthenticatorError.AccessTokenMissing
                }
                
                fulfill(accessToken)
                
            }.error { error in
                reject(error)
            }
        }
    }
    
    func decodeRequestTokenFromQuery(query: String) -> Promise<String> {
        return Promise<String> { fulfill, _ in
            
            guard let requestToken = query.dictionary["code"] else {
                throw AuthenticatorError.AuthTokenMissing
            }
            
            fulfill(requestToken)
        }
    }
}

// MARK: - Query Convertible
private extension String {
    
    var dictionary: [String: String] {
        var parameters = [String: String]()
        
        let scanner = NSScanner(string: self)
        var name: NSString?
        var value: NSString?
        
        repeat {
            
            name = nil
            value = nil
            
            scanner.scanUpToString("=", intoString:&name)
            scanner.scanString("=", intoString: nil)
            
            scanner.scanUpToString("&", intoString:&value)
            scanner.scanString("&", intoString: nil)
            
            if let name = name?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
                value = value?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                    parameters[name] = value
            }
        } while !scanner.atEnd
        
        return parameters
    }
}
