//
//  Authenticator.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class Authenticator {
    
    private let interactionHandler: (UIViewController -> Void)
    
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
    
    func loginWithService(service: Service, trySilent: Bool = true) -> Promise<Void> {
        
        let serviceInstance = service.instance
        var controller: OAuthViewController!
        
        if let oAuthAuthorizableService = serviceInstance as? OAuthAuthorizable {
            
            controller = OAuthViewController(oAuthAuthorizableService: oAuthAuthorizableService) { controller in
                if trySilent {
                    
                    let controller = self.navigationControllerByEmbeddingController(controller)
                    self.interactionHandler(controller)
                }
            }
        } else {
            // FUTURE:
            // in case of other services integration which don't support oAuth authentication
            // please define controller here
        }
        
        if !trySilent {
            let controller = self.navigationControllerByEmbeddingController(controller)
            interactionHandler(controller)
        }
        
        return Promise<Void> { fulfill, reject in
            firstly {
                controller.startAuthentication()
            }.then { accessToken in
                self.persistToken(accessToken)
            }.then {
                self.fetchUser()
            }.then { user in
                self.persistUser(user)
            }.then {
                fulfill()
            }.error { error in
                reject(error)
            }
        }
    }
    
    class func logout() {
        UserStorage.clear()
        TokenStorage.clear()
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
    
    func persistToken(token: String) -> Promise<Void> {
        TokenStorage.storeToken(token)
        return Promise()
    }
    
    func persistUser(user: User) -> Promise<Void> {
        UserStorage.storeUser(user)
        return Promise()
    }
    
    func navigationControllerByEmbeddingController(controller: UIViewController) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barStyle = .Black
        
        return navigationController
    }
}
