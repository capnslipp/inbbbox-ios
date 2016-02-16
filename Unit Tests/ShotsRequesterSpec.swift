//
//  ShotsRequesterSpec.swift
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

class ShotsRequesterSpec: QuickSpec {
    override func spec() {
        
        var sut: ShotsRequester!
        var error: ErrorType?
        var didInvokePromise: Bool?
        
        beforeEach {
            sut = ShotsRequester()
        }
        
        afterEach {
            sut = nil
            error = nil
            didInvokePromise = nil
            self.removeAllStubs()
        }
        
        describe("when liking shot") {
            
            context("and token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should appear") {
                    sut.likeShot(Shot.fixtureShot()).then { _ in
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
                    self.stub(everything, builder: json([], status: 201))
                }
                
                it("should like shot") {
                    sut.likeShot(Shot.fixtureShot()).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
        
        describe("when unliking shot") {
            
            context("and token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should appear") {
                    sut.unlikeShot(Shot.fixtureShot()).then { _ in
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
                
                it("should like shot") {
                    sut.unlikeShot(Shot.fixtureShot()).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
        
        describe("when checking if authenticated user like shot") {
            
            
            context("and token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should appear") {
                    sut.isShotLikedByMe(Shot.fixtureShot()).then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("and server respond with 200") {
                
                var isLikedByMe: Bool?
                
                beforeEach {
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json([], status: 200))
                }
                
                afterEach {
                    isLikedByMe = nil
                }
                
                it("shot should be liked by authenticated user") {
                    sut.isShotLikedByMe(Shot.fixtureShot()).then { _isLikedByMe in
                        isLikedByMe = _isLikedByMe
                    }.error { _ in fail() }
                    
                    expect(isLikedByMe).toNotEventually(beNil())
                    expect(isLikedByMe).toEventually(beTruthy())
                }
            }
            
            context("and server respond with 404") {
                
                var isLikedByMe: Bool?
                
                beforeEach {
                    TokenStorage.storeToken("fixture.token")
                    let error = NSError(domain: "fixture.domain", code: 404, userInfo: nil)
                    self.stub(everything, builder: failure(error))
                }
                
                afterEach {
                    isLikedByMe = nil
                }
                
                it("shot should not be liked by authenticated user") {
                    sut.isShotLikedByMe(Shot.fixtureShot()).then { _isLikedByMe in
                        isLikedByMe = _isLikedByMe
                    }.error { _ in fail() }
                    
                    expect(isLikedByMe).toNotEventually(beNil())
                    expect(isLikedByMe).toEventually(beFalsy())
                }
            }
        }
    }
}
