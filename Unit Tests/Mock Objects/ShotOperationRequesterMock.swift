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

class ShotOperationRequesterMock: ShotOperationRequester {

    static let likeShotStub = Stub<String, Promise<Void>>()

    override class func likeShot(shotID: String) -> Promise<Void> {
        return try! likeShotStub.invoke(shotID)
    }
}
