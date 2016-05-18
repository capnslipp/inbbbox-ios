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

    private let interactionHandler: (UIViewController -> Void)
    var safari: SFSafariViewController?

    enum Service {
        case Dribbble

        var instance: NetworkService {
            switch self {
                case .Dribbble: return DribbbleNetworkService()
            }
        }
    }

    init(interactionHandler: (UIViewController -> Void)) {
        self.interactionHandler = interactionHandler
    }

    func newLoginWithService(service: Service, trySient: Bool = true) {
        let serviceInstance = service.instance
        var fakeController: OAuthViewController?

        if let oAuthAuthorizableService = serviceInstance as? OAuthAuthorizable {
            fakeController = OAuthViewController(oAuthAuthorizableService: oAuthAuthorizableService) {
                controller, url in
                print("\(url.absoluteString)")
                self.safari = SFSafariViewController(URL: url)
                self.safari!.delegate = self
                self.interactionHandler(UINavigationController(rootViewController: self.safari!))
            }
        }

        fakeController?.startAuthentication()
    }

    func loginWithService(service: Service, trySilent: Bool = true) -> Promise<Void> {

        let serviceInstance = service.instance
        var controller: OAuthViewController!

        if let oAuthAuthorizableService = serviceInstance as? OAuthAuthorizable {

            controller = OAuthViewController(oAuthAuthorizableService: oAuthAuthorizableService) {
                    controller, url in
                if trySilent {
                    self.interactionHandler(UINavigationController(rootViewController: controller))
                }
            }
        } else {
            // FUTURE:
            // in case of other services integration which don't support oAuth authentication
            // please define controller here
        }

        if !trySilent {
            interactionHandler(UINavigationController(rootViewController: controller))
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
        Authenticator.clearCookies()
        APIRateLimitKeeper.sharedKeeper.clearRateLimitsInfo()
    }

    class func clearCookies() {
        WKWebsiteDataStore.defaultDataStore().removeDataOfTypes([WKWebsiteDataTypeCookies],
                                                                modifiedSince:NSDate(timeIntervalSince1970: 0), completionHandler: {})
    }
}

extension Authenticator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        print("[Authenticator] safariViewControllerDidFinish")
    }

    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("[Authenticator] didCompleteInitialLoad")
    }
}

private extension Authenticator {

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
