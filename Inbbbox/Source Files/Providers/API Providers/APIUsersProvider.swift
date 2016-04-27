//
//  APIUsersProvider.swift
//  Inbbbox
//
//  Created by Peter Bruz on 27/04/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/// Provides interface for dribbble comments read API
class APIUsersProvider: PageableProvider {

    /**
     Provides user for given identifier.

     - parameter identifier: User's identifier.

     - returns: Promise which resolves with User or nil.
     */
    func provideUser(identifier: String) -> Promise<UserType> {

        let query = UserQuery(identifier: identifier)
        return Promise<UserType> { fulfill, reject in
            
            let request = Request(query: query)

            firstly {
                request.resume()
            }.then { json -> Void in
                guard let json = json else { throw AuthenticatorError.UnableToFetchUser }

                fulfill(User.map(json) as UserType)

                }.error { error in
                    reject(error)
            }
        }
    }
}
