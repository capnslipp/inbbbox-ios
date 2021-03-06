//
//  Authenticator.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import WebKit
import SafariServices

class Authenticator {

    var networkService: OAuthAuthorizable?

    private let interactionHandler: (SFSafariViewController -> Void)
    private let success: (Void -> Void)
    private let failure: (ErrorType -> Void)

    enum Service {
        case Dribbble

        var instance: NetworkService {
            switch self {
                case .Dribbble: return DribbbleNetworkService()
            }
        }
    }

    // MARK: Init

    init(service: Service,
         interactionHandler: (SFSafariViewController -> Void),
         success: (() -> Void),
         failure: (ErrorType -> Void)) {
        self.networkService = service.instance as? OAuthAuthorizable
        self.interactionHandler = interactionHandler
        self.success = success
        self.failure = failure
    }

    // MARK: Public

    func login() {
        if let networkService = networkService {
            let controller = SFSafariViewController(URL: networkService.requestTokenURLRequest().URL!)
            controller.view.tintColor = .pinkColor()
            interactionHandler(controller)
        } else {
            self.failure(AuthenticatorError.RequestTokenURLFailure)
        }
    }

    func loginWithOAuthURLCallback(url: NSURL) {
        login(url)
    }

    class func logout() {
        UserStorage.clearUser()
        TokenStorage.clear()
        APIRateLimitKeeper.sharedKeeper.clearRateLimitsInfo()
    }
}

// MARK: Private

private extension Authenticator {

    func login(url: NSURL) {
        firstly {
            decodeRequestTokenFromCallback(url)
        }.then { requestToken in
            self.gainAccessTokenWithRequestToken(requestToken)
        }.then { accessToken in
            self.persistToken(accessToken)
        }.then {
            self.fetchUser()
        }.then { user in
            self.persistUser(user)
        }.then { () -> Void in
            AnalyticsManager.trackLoginEvent(AnalyticsLoginEvent.LoginSucceeded)
            self.success()
        }.error { error in
            AnalyticsManager.trackLoginEvent(AnalyticsLoginEvent.LoginFailed)
            self.failure(error)
        }
    }

    func decodeRequestTokenFromCallback(url: NSURL) -> Promise<String> {
        return Promise { fulfill, reject in
            var code: String?
            let components = url.query?.componentsSeparatedByString("&")
            if let components = components {
                for component in components {
                    if component.rangeOfString("code=") != nil {
                        code = component.componentsSeparatedByString("=").last
                    }
                }
                code != nil ? fulfill(code!) : reject(AuthenticatorError.AuthTokenMissing)
            } else {
                reject(AuthenticatorError.AuthTokenMissing)
            }
        }
    }

    func gainAccessTokenWithRequestToken(token: String) -> Promise<String> {
        return Promise<String> { fulfill, reject in

            guard let request = self.networkService?.accessTokenURLRequestWithRequestToken(token) else {
                return reject(AuthenticatorError.AuthTokenMissing)
            }

            firstly {
                return NSURLSession.POST(request.URL!.absoluteString)
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

    func fetchUser() -> Promise<User> {
        return Promise<User> { fulfill, reject in

            let query = UserQuery()
            let request = Request(query: query)

            firstly {
                request.resume()
            }.then { json -> Void in
                guard let json = json else {
                    throw AuthenticatorError.UnableToFetchUser
                }
                fulfill(User.map(json))

            }.error { error in
                reject(error)
            }
        }
    }

    func persistToken(token: String) {
        TokenStorage.storeToken(token)
    }

    func persistUser(user: User) {
        UserStorage.storeUser(user)
        UserStorage.clearGuestUser()
    }
}
