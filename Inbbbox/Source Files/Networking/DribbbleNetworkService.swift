//
//  DribbbleNetworkService.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct DribbbleNetworkService: SecureNetworkService, HeaderAuthorizable, OAuthAuthorizable {
    
    //MARK: SecureNetworkService
    let host = Dribbble.Host
    let version = Dribbble.APIVersion
    
    //MARK: OAuthAuthorizable
    let requestTokenURLString = Dribbble.RequestTokenURLString
    let accessTokenURLString = Dribbble.AccessTokenURLString
    let redirectURI = Dribbble.CallbackURLString
    let clientID = Dribbble.ClientID
    let clientSecret = Dribbble.ClientSecret
    let scope = Dribbble.Scope
    
    func authorizeRequest(request: NSMutableURLRequest) {
        
        let token = TokenStorage.currentToken ?? Dribbble.ClientAccessToken
        let header = authorizationHeader(token)
        request.setHeader(header)
    }
}

extension NSMutableURLRequest {
    func setHeader(header: HTTPHeader) {
        setValue(header.value, forHTTPHeaderField: header.name)
    }
}
