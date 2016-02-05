//
//  ShotsProviderSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 05/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import PromiseKit

@testable import Inbbbox

class ShotsProviderSpec: QuickSpec {
    override func spec() {
        
        var sut: MockShotsProvider!
        var shots: [Shot]?
        
        afterEach {
            sut = nil
            shots = nil
        }
        
        describe("when init with custom initializer") {
            
            beforeEach {
                sut = MockShotsProvider(page: 2, pagination: 10)
            }
            
            it("should have properly set page") {
                expect(sut.page).to(equal(2))
            }
            
            it("should have properly set pagination") {
                expect(sut.pagination).to(equal(10))
            }
        }
        
        describe("when init with convenience initializer") {
            
            beforeEach {
                sut = MockShotsProvider()
            }
            
            it("should have properly set page") {
                expect(sut.page).to(equal(1))
            }
            
            it("should have properly set pagination") {
                expect(sut.pagination).to(equal(30))
            }
            
            context("when providing shots") {
                
                it("shots should be properly returned") {
                    sut.provideShots().then { _shots -> Void in
                        shots = _shots
                    }.error { _ in fail() }
                    
                    expect(shots).toNotEventually(beNil())
                    expect(shots).toEventually(haveCount(2))
                }
            }
            
            context("when providing shots for user") {
                
                it("shots should be properly returned") {
                    sut.provideShotsForUser(User.fixtureUser()).then { _shots -> Void in
                        shots = _shots
                    }.error { _ in fail() }
                    
                    expect(shots).toNotEventually(beNil())
                    expect(shots).toEventually(haveCount(2))
                }
            }
            
            context("when providing shots for bucket") {
                
                it("shots should be properly returned") {
                    sut.provideShotsForBucket(Bucket.fixtureBucket()).then { _shots -> Void in
                        shots = _shots
                    }.error { _ in fail() }
                    
                    expect(shots).toNotEventually(beNil())
                    expect(shots).toEventually(haveCount(2))
                }
            }
            
            context("when providing shots from next/previous page") {
                
                var error: ErrorType!
                
                afterEach {
                    error = nil
                }
                
                context("without using any of provide method first") {
                    
                    it("should raise an error") {
                        sut.nextPage().then { _ -> Void in
                            fail()
                        }.error { _error in
                            error = _error
                        }
                        
                        expect(error is PageableProviderError).toEventually(beTruthy())
                    }
                    
                    it("should raise an error") {
                        sut.previousPage().then { _ -> Void in
                            fail()
                        }.error { _error in
                            error = _error
                        }
                        
                        expect(error is PageableProviderError).toEventually(beTruthy())
                    }
                }
                
                context("with using provide method first") {
                    
                    beforeEach {
                        sut.provideShots()
                    }
                    
                    it("shots should be properly returned") {
                        sut.nextPage().then { _shots -> Void in
                            shots = _shots
                        }.error { _ in fail() }
                        
                        expect(shots).toNotEventually(beNil())
                        expect(shots).toEventually(haveCount(2))
                    }
                    
                    
                    it("shots should be properly returned") {
                        sut.previousPage().then { _shots -> Void in
                            shots = _shots
                        }.error { _ in fail() }
                        
                        expect(shots).toNotEventually(beNil())
                        expect(shots).toEventually(haveCount(2))
                    }
                    
                }
            }
        }
    }
}

//Explanation: Create MockShotsProvider to override methods from PageableProvider.
private class MockShotsProvider: ShotsProvider {
    
    override func firstPageForQueries<T: Mappable>(queries: [Query]) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func nextPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func previousPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    func mockResult<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, _ in
            
            let configuration = [
                (identifier: 1, animated: true),
                (identifier: 2, animated: false),
                (identifier: 3, animated: false),
                (identifier: 3, animated: false)
            ]
            
            let json = JSONSpecLoader.sharedInstance.fixtureShotJSON(configuration)
            let result = json.map { T.map($0) }
            
            fulfill(result)
        }
    }
}
