//
//  CommentsProviderMock.swift
//  Inbbbox
//
//  Created by Peter Bruz on 22/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class CommentsProviderMock: CommentsProvider {
    
    let provideCommentsForShotStub = Stub<Shot,Promise<[Comment]?>>()
    let nextPageStub = Stub<Void,Promise<[Comment]?>>()

    override func provideCommentsForShot(shot: Shot) -> Promise<[Comment]?> {
        return try! provideCommentsForShotStub.invoke(shot)
    }
    
    override func nextPage() -> Promise<[Comment]?> {
        return try! nextPageStub.invoke()
    }
}
