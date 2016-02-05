//
//  ShotsLocalStorageSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotsLocalStorageSpec: QuickSpec {
    
    override func spec() {
        
        let sut = ShotsLocalStorage(managedContext: setUpInMemoryManagedObjectContext())
        
        let fixtureShotId1 = "11"
        let fixtureShotId2 = "22"
        
        let bucketsStorage = BucketsLocalStorage(managedContext: sut.managedContext)
        let fixtureBucketId1 = "1"
        let fixtureBucketName1 = "fixture.bucket.name1"
        let fixtureBucketId2 = "2"
        let fixtureBucketName2 = "fixture.bucket.name2"
        
        describe("when liking shots") {
            
            beforeEach {
                try! sut.like(shotID: fixtureShotId1)
                try! sut.like(shotID: fixtureShotId2)
            }
            
            it("storage should have 2 liked shots") {
                expect(sut.likedShots.count).to(equal(2))
            }
            
            describe("when unliking shots") {
                
                beforeEach {
                    try! sut.unlike(shotID: fixtureShotId1)
                    try! sut.unlike(shotID: fixtureShotId2)
                }
                
                it("storage should be empty") {
                    expect(sut.likedShots.count).to(equal(0))
                }
            }
        }
        
        beforeEach {
            try! bucketsStorage.create(bucketID: fixtureBucketId1, name: fixtureBucketName1)
            try! bucketsStorage.create(bucketID: fixtureBucketId2, name: fixtureBucketName2)
        }
        
        afterEach {
            try! bucketsStorage.destroy(bucketID: fixtureBucketId1)
            try! bucketsStorage.destroy(bucketID: fixtureBucketId2)
        }
        
        describe("when playing with buckets") {
            
            describe("when adding to bucket") {
                
                beforeEach {
                    try! sut.addToBucket(shotID: fixtureShotId1, bucketID: fixtureBucketId1)
                    try! sut.addToBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId1)
                    try! sut.addToBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId2)
                }
                
                it("shot1 should have 1 bucket") {
                    let shot1 = sut.shots[0]
                    expect(shot1.buckets?.count).to(equal(1))
                }
                
                it("shot2 should have 2 buckets") {
                    let shot2 = sut.shots[1]
                    expect(shot2.buckets?.count).to(equal(2))
                }
                
                describe("when removing shots from bucket") {
                    
                    beforeEach {
                        try! sut.removeFromBucket(shotID: fixtureShotId1, bucketID: fixtureBucketId1)
                        try! sut.removeFromBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId1)
                        try! sut.removeFromBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId2)
                    }
                    
                    it("should not be any shot in storage") {
                        expect(sut.shots.count).to(equal(0))
                    }
                }
            }
        }
        
        describe("when interacting both likes and buckets") {
            
            beforeEach {
                try! sut.like(shotID: fixtureShotId1)
                try! sut.like(shotID: fixtureShotId2)

                try! sut.addToBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId1)
                
                try! sut.unlike(shotID: fixtureShotId1)
                try! sut.unlike(shotID: fixtureShotId2)
            }
            
            afterEach {
                try! sut.removeFromBucket(shotID: fixtureShotId2, bucketID: fixtureBucketId1)
            }
            
            it("storage should have 1 shot") {
                expect(sut.shots.count).to(equal(1))
            }
        }
    }
}
