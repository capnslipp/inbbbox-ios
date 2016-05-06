//
//  UserToURLProvider.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 31.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Provide URL represantation of user from user.
/// Uses user's identifier to create URL.
/// Helps with using TTTAttributedLabel in the project.

protocol UserToURLProvider {


    /// Converts user to URL represantation of user.
    ///
    /// - parameter user: Team that is converted.
    ///
    /// - returns: URL represantation of user.
    func urlForUser(user: UserType) -> NSURL?

    /// Converts team to URL represantation of team.
    ///
    /// - parameter team: Team that is converted.
    ///
    /// - returns: URL represantation of team.
    func urlForTeam(team: TeamType) -> NSURL?

}

extension UserToURLProvider {

    func urlForUser(user: UserType) -> NSURL? {
        return NSURL(string: user.identifier)
    }

    func urlForTeam(team: TeamType) -> NSURL? {
        return NSURL(string: team.identifier)
    }
}
