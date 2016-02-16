//
//  ShotOperationRequesterMock.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/5/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Dobby
import PromiseKit

@testable import Inbbbox

class ShotsRequesterMock: ShotsRequester {

    let likeShotStub = Stub<Shot, Promise<Void>>()

    override func likeShot(shot: Shot) -> Promise<Void> {
        return try! likeShotStub.invoke(shot)
    }
}
