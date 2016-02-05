//
//  BucketsLocalStorageSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class BucketsLocalStorageSpec: QuickSpec {
    
    override func spec() {
        
        let sut = BucketsLocalStorage(managedContext: setUpInMemoryManagedObjectContext())
        
        describe("when creating bucket") {
            
            let fixtureBucketId = "1"
            let fixtureBucketName = "fixture.bucket.name"
            
            beforeEach {
                try! sut.create(bucketID: fixtureBucketId, name: fixtureBucketName)
            }
            
            it("there should be 1 bucket") {
                expect(sut.buckets.count).to(equal(1))
            }
            
            describe("when destroying bucket") {
                
                beforeEach {
                    try! sut.destroy(bucketID: fixtureBucketId)
                }
                
                it("there shouldn't be any bucket") {
                    expect(sut.buckets.count).to(equal(0))
                }
            }
        }
    }
}
