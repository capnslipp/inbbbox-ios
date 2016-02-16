//
//  BucketsRequesterSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit
import Mockingjay

@testable import Inbbbox

class BucketsRequesterSpec: QuickSpec {
    override func spec() {
        
        var sut: BucketsRequester!
        var error: ErrorType?
        var didInvokePromise: Bool?
        
        beforeEach {
            sut = BucketsRequester()
        }
        
        afterEach {
            sut = nil
            error = nil
            didInvokePromise = nil
            self.removeAllStubs()
        }
        
        describe("when adding shot to bucket") {
            
            context("and token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should appear") {
                    sut.addShot(Shot.fixtureShot(), toBucket: Bucket.fixtureBucket()).then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("and token does exist") {
                
                beforeEach {
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json([], status: 204))
                }
                
                it("should add shot to bucket") {
                    sut.addShot(Shot.fixtureShot(), toBucket: Bucket.fixtureBucket()).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
        
        describe("when removing shot from bucket") {
            
            context("and token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should appear") {
                    sut.removeShot(Shot.fixtureShot(), fromBucket: Bucket.fixtureBucket()).then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("and token does exist") {
                
                beforeEach {
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json([], status: 204))
                }
                
                it("should remove shot from bucket") {
                    sut.removeShot(Shot.fixtureShot(), fromBucket: Bucket.fixtureBucket()).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
    }
}
