//
//  APIConnectionsRequesterMock.swift
//  Inbbbox
//
//  Created by Peter Bruz on 15/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class APIConnectionsRequesterMock: APIConnectionsRequester {
    
    let isUserFollowedByMeStub = Stub<UserType, Promise<Bool>>()
    let followUserStub = Stub<UserType, Promise<Void>>()
    let unfollowUserStub = Stub<UserType, Promise<Void>>()

    override func isUserFollowedByMe(user: UserType) -> Promise<Bool> {
        return try! isUserFollowedByMeStub.invoke(user)
    }
    
    override func followUser(user: UserType) -> Promise<Void> {
        return try! followUserStub.invoke(user)
    }
    
    override func unfollowUser(user: UserType) -> Promise<Void> {
        return try! unfollowUserStub.invoke(user)
    }
}
