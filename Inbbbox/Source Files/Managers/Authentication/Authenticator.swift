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

class Authenticator: NSObject {

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

    init(interactionHandler: (SFSafariViewController -> Void), success: (Void -> Void), failure: (ErrorType -> Void)) {
        self.interactionHandler = interactionHandler
        self.success = success
        self.failure = failure

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(safariControllerDidSendNotification(_:)),
                                                         name: Dribbble.SafariControllerDidReceiveCallbackNotification,
                                                         object: nil)
    }

    deinit {
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // TODO (PIKOR): Change name
    func loginSafariWithService(service: Service, trySilent: Bool = true) -> Void {
        if trySilent {
            // TODO (PIKOR): Implement
        } else {
            let url = DribbbleNetworkService().requestTokenURLRequest().URL!
            interactionHandler(SFSafariViewController(URL: url))
        }
    }

    // Will be removed when done with Safari.
    func loginWithService(service: Service, trySilent: Bool = true) -> Promise<Void> {

        let serviceInstance = service.instance
        var controller: OAuthViewController!

        if let oAuthAuthorizableService = serviceInstance as? OAuthAuthorizable {

            controller = OAuthViewController(oAuthAuthorizableService: oAuthAuthorizableService) {
                    controller in
                if trySilent {
//                    self.interactionHandler(UINavigationController(rootViewController: controller))
                }
            }
        } else {
            // FUTURE:
            // in case of other services integration which don't support oAuth authentication
            // please define controller here
        }

        if !trySilent {
//            interactionHandler(UINavigationController(rootViewController: controller))
        }

        return Promise<Void> { fulfill, reject in
            firstly {
                controller.startAuthentication()
            }.then { accessToken -> Void in
                self.persistToken(accessToken)
            }.then {
                self.fetchUser()
            }.then { user in
                self.persistUser(user)
            }.then { () -> Void in
                AnalyticsManager.trackLoginEvent(AnalyticsLoginEvent.LoginSucceeded)
                fulfill()
            }.error { error -> Void in
                AnalyticsManager.trackLoginEvent(AnalyticsLoginEvent.LoginFailed)
                reject(error)
            }
        }
    }

    class func logout() {
        UserStorage.clear()
        TokenStorage.clear()
        WKWebsiteDataStore.defaultDataStore().removeDataOfTypes([WKWebsiteDataTypeCookies],
                modifiedSince:NSDate(timeIntervalSince1970: 0), completionHandler: {})
        APIRateLimitKeeper.sharedKeeper.clearRateLimitsInfo()
    }
}

private extension Authenticator {

    dynamic func safariControllerDidSendNotification(notification: NSNotification) {

        guard let callbackURL = notification.object as? NSURL else {
            failure(AuthenticatorError.InvalidCallbackURL)
            return
        }

        proceed(callbackURL)
    }

    func proceed(url: NSURL) {
        firstly {
            decodeRequestTokenFromCallback(url)
        }.then { requestToken in
            self.gainAccessTokenWithReqestToken(requestToken)
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

    }

    func gainAccessTokenWithReqestToken(token: String) -> Promise<String> {
        return Promise<String> { fulfill, reject in

            let request = DribbbleNetworkService().accessTokenURLRequestWithRequestToken(token)

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
    }
}
