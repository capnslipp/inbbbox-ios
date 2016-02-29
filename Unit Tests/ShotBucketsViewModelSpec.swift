//
//  ShotBucketsViewModelSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 28/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit
import Dobby

@testable import Inbbbox

class ShotBucketsViewModelSpec: QuickSpec {

    override func spec() {
        
        var sut: ShotBucketsViewModel!
        var shot: ShotType!
        var bucketsProviderMock: APIBucketsProviderMock!
        var bucketsRequesterMock: APIBucketsRequesterMock!
        var shotsRequesterMock: APIShotsRequesterMock!
        
        beforeEach {
            
            shot = Shot.fixtureShot()
            bucketsProviderMock = APIBucketsProviderMock()
            bucketsRequesterMock = APIBucketsRequesterMock()
            shotsRequesterMock = APIShotsRequesterMock()
            
            bucketsProviderMock.provideMyBucketsStub.on(any()) { _ in
                return Promise{ fulfill, _ in
                    
                    let json = JSONSpecLoader.sharedInstance.fixtureBucketsJSON(withCount: 2)
                    let result = json.map { Bucket.map($0) }
                    var resultBucketTypes = [BucketType]()
                    for bucket in result {
                        resultBucketTypes.append(bucket)
                    }
                    
                    fulfill(resultBucketTypes)
                }
            }
            
            bucketsRequesterMock.addShotStub.on(any()) { _ in
                return Promise()
            }
            
            bucketsRequesterMock.removeShotStub.on(any()) { _ in
                return Promise()
            }
            
            shotsRequesterMock.userBucketsForShotStub.on(any()) { _ in
                return Promise{ fulfill, _ in
                    
                    let json = JSONSpecLoader.sharedInstance.fixtureBucketsJSON(withCount: 3)
                    let result = json.map { Bucket.map($0) }
                    var resultBucketTypes = [BucketType]()
                    for bucket in result {
                        resultBucketTypes.append(bucket)
                    }
                    
                    fulfill(resultBucketTypes)
                }
            }
        }
        
        afterEach {
            bucketsProviderMock = nil
            bucketsRequesterMock = nil
            shotsRequesterMock = nil
            shot = nil
        }
        
        context("adding shot to bucket") {
            
            beforeEach {
                sut = ShotBucketsViewModel(shot: shot, mode: .AddToBucket)
                
                sut.bucketsProvider = bucketsProviderMock
                sut.bucketsRequester = bucketsRequesterMock
            }
            
            afterEach {
                sut = nil
            }
            
            describe("when newly initialized") {
                
                it("should have correct title") {
                    expect(sut.titleForHeader).to(equal("Add To Bucket"))
                }
                
                it("should have no buckets") {
                    expect(sut.buckets.count).to(equal(0))
                }
                
                it("should have no items") {
                    expect(sut.itemsCount).to(equal(0))
                }
            }
            
            describe("when buckets are loaded") {
                
                var responseResult: String!
                let successResponse = "success"
                
                beforeEach {
                    waitUntil { done in
                        sut.loadBuckets().then { result -> Void in
                            responseResult = successResponse
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                }
                
                afterEach {
                    responseResult = nil
                }
                
                it("buckets should be properly downloaded") {
                    expect(responseResult).to(equal(successResponse))
                }
                
                it("view model should have correct number of buckets") {
                    expect(sut.buckets.count).to(equal(2))
                }
                
                it("view model should have correct number of items") {
                    expect(sut.itemsCount).to(equal(2))
                }
            }
            
            describe("when adding shot to bucket") {
                
                var responseResult: String!
                let successResponse = "success"
                
                beforeEach {
                    waitUntil { done in
                        sut.loadBuckets().then { result -> Void in
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                    
                    waitUntil { done in
                        sut.addShotToBucketAtIndex(0).then { result -> Void in
                            responseResult = successResponse
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                }
                
                afterEach {
                    responseResult = nil
                }
                
                it("should be correctly added") {
                    expect(responseResult).to(equal(successResponse))
                }
            }
        }
        
        context("removing shot from buckets") {
            
            beforeEach {
                sut = ShotBucketsViewModel(shot: shot, mode: .RemoveFromBucket)
                
                sut.shotsRequester = shotsRequesterMock
                sut.bucketsRequester = bucketsRequesterMock
            }
            
            afterEach {
                sut = nil
            }
            
            describe("when newly initialized") {
                
                it("should have correct title") {
                    expect(sut.titleForHeader).to(equal("Remove From Bucket"))
                }
                
                it("should have no buckets") {
                    expect(sut.buckets.count).to(equal(0))
                }
                
                it("should have correct number of items") {
                    expect(sut.itemsCount).to(equal(2))
                }
            }
            
            describe("when buckets for shot are loaded") {
                
                var responseResult: String!
                let successResponse = "success"
                
                beforeEach {
                    waitUntil { done in
                        sut.loadBuckets().then { result -> Void in
                            responseResult = successResponse
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                }
                
                afterEach {
                    responseResult = nil
                }
                
                it("buckets should be properly downloaded") {
                    expect(responseResult).to(equal(successResponse))
                }
                
                it("view model should have correct number of buckets") {
                    expect(sut.buckets.count).to(equal(3))
                }
                
                it("view model should have correct number of items") {
                    expect(sut.itemsCount).to(equal(5))
                }
            }
            
            describe("when removing shot from selected buckets") {
                
                var responseResult: String!
                let successResponse = "success"
                
                beforeEach {
                    waitUntil { done in
                        sut.loadBuckets().then { result -> Void in
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                    
                    sut.selectBucketAtIndex(0)
                    sut.selectBucketAtIndex(1)
                    
                    waitUntil { done in
                        sut.removeShotFromSelectedBuckets().then { result -> Void in
                            responseResult = successResponse
                            done()
                        }.error { _ in fail("This should not be invoked") }
                    }
                }
                
                afterEach {
                    responseResult = nil
                }
                
                it("shot should be properly removed from selected buckets") {
                    expect(responseResult).to(equal(successResponse))
                }
            }
        }
    }
}
