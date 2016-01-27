//
//  ShotsProviderSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import Mockingjay

@testable import Inbbbox

class ShotsProviderSpec: QuickSpec {
    override func spec() {
        
        var sut: ShotsProvider!
        
        afterEach {
            sut = nil
        }
        
        describe("when init with convenience initializer") {
            
            beforeEach {
                sut = ShotsProvider()
            }
        
            it("should have properly set page") {
                expect(sut.page).to(equal(1))
            }
            
            context("when providing shots with success") {
                
                beforeEach {
                    sut = ShotsProvider()
                    self.stub(everything, builder: json(self.fixtureJSON))
                }
                
                afterEach {
                    self.removeAllStubs()
                }
                
                it("should return 2 shots") {
                    var shots: [Shot]!
                    
                    sut.provideShots().then { _shots in
                        shots = _shots
                    }.error { _ in
                        fail()
                    }
                    
                    expect(shots).toEventually(haveCount(2))
                }
                
                it("page should be increased") {
                    
                    waitUntil { done in
                        
                        sut.provideShots().then {_ in
                            done()
                        }.error { _ in
                            fail()
                        }
                    }
                    
                    expect(sut.page).to(equal(2))
                }

                it("after restoring, page should be 1") {
                    
                    waitUntil { done in
                        
                        sut.provideShots().then {_ in
                            done()
                        }.error { _ in
                            fail()
                        }
                    }
                    
                    sut.restoreInitialState()
                    expect(sut.page).to(equal(1))
                }
            }
            
            context("when providing shots with error") {
                
                var error: ErrorType!
                
                beforeEach {
                    sut = ShotsProvider()
                    let error = NSError(domain: "", code: 0, message: "")
                    self.stub(everything, builder: failure(error))
                }
                
                afterEach {
                    error = nil
                    self.removeAllStubs()
                }
                
                it("error should be returned") {
                    
                    sut.provideShots().then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error).toNotEventually(beNil())
                }
            }
        }
        
        describe("when init with custom initializer") {
            
            beforeEach {
                sut = ShotsProvider(page: 10, pagination: 10, configuration: MockShotsProviderConfiguration())
            }
            
            it("should have properly set page") {
                expect(sut.page).to(equal(10))
            }
            
            it("should have properly set pagination") {
                expect(sut.pagination).to(equal(10))
            }
            
            it("should have properly set configuration") {
                expect(sut.configuration is MockShotsProviderConfiguration).to(beTruthy())
            }
        }
    }
}

class MockShotsProviderConfiguration: ShotsProviderConfiguration {}

private extension ShotsProviderSpec {
    
    var fixtureJSON: [[String: AnyObject]] {
        
        let configuration = [
            (identifier: 1, animated: true),
            (identifier: 2, animated: false),
            (identifier: 3, animated: false),
            (identifier: 3, animated: false)
        ]
        
        return JSONSpecLoader.sharedInstance.fixtureShotJSON(configuration)
    }
}
