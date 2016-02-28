//
//  APIBucketsProviderMock.swift
//  Inbbbox
//
//  Created by Peter Bruz on 28/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class APIBucketsProviderMock: APIBucketsProvider {
    
    let provideMyBucketsStub = Stub<Void, Promise<[BucketType]?>>()
    let nextPageStub = Stub<Void, Promise<[CommentType]?>>()
    
    override func provideMyBuckets() -> Promise<[BucketType]?> {
        return try! provideMyBucketsStub.invoke()
    }
}
