//
//  APIBucketsRequesterMock.swift
//  Inbbbox
//
//  Created by Peter Bruz on 28/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class APIBucketsRequesterMock: APIBucketsRequester {
    
    let addShotStub = Stub<(ShotType, BucketType), Promise<Void>>()
    let removeShotStub = Stub<(ShotType, BucketType), Promise<Void>>()
    
    override func addShot(shot: ShotType, toBucket bucket: BucketType) -> Promise<Void> {
        return try! addShotStub.invoke(shot, bucket)
    }
    
    override func removeShot(shot: ShotType, fromBucket bucket: BucketType) -> Promise<Void> {
        return try! removeShotStub.invoke(shot, bucket)
    }
}
