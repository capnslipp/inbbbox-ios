//
//  ShotOperationHistoryStorageSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotOperationHistoryStorageSpec: QuickSpec {
    
    override func spec() {
        
        let sut = ShotOperationHistoryStorage(managedContext: setUpInMemoryManagedObjectContext())
        
        let fixtureShotId = "1"
        let fixtureBucketId = "1"
        
        describe("when operate on shots and buckets") {
            
            beforeEach {
                try! sut.insertRecord(fixtureShotId, operation: .Like)
                try! sut.insertRecord(fixtureShotId, operation: .AddToBucket, bucketID: fixtureBucketId)
                try! sut.insertRecord(fixtureShotId, operation: .Unlike)
                try! sut.insertRecord(fixtureShotId, operation: .RemoveFromBucket, bucketID: fixtureBucketId)
            }
            
            it("storage should have 4 records") {
                expect(try! sut.allRecords()?.count).to(equal(4))
            }
            
            describe("when cleaning history") {
                
                beforeEach {
                    try! sut.clearHistory()
                }
                
                it("storage should be empty") {
                    expect(try! sut.allRecords()?.count).to(equal(0))
                }
            }
        }
    }
}
