//
//  APIShotsProviderMock.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 3/1/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class APIShotsProviderMock: APIShotsProvider {

    let provideMyLikedShotsStub = Stub<Void, Promise<[ShotType]?>>()

    override func provideMyLikedShots() -> Promise<[ShotType]?> {
        return try! provideMyLikedShotsStub.invoke()
    }
}
