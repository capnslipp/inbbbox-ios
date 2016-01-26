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
        return [
            [
                "id": 2479405,
                "title": "fixture.title.1",
                "description": "fixture.description.1",
                "animated": true,
                "created_at" : "2016-01-25T08:19:14Z",
                "user": fixtureUserJSON,
                "images": fixtureImagesJSON
            ],[
                "id": 2479406,
                "title": "fixture.title.2",
                "description": "fixture.description.2",
                "animated": false,
                "created_at" : "2016-01-25T08:19:14Z",
                "user": fixtureUserJSON,
                "images": fixtureImagesJSON
            ],[
                "id": 2479407,
                "title": "fixture.title.3",
                "description": "fixture.description.3",
                "animated": false,
                "created_at" : "2016-01-25T08:19:14Z",
                "user": fixtureUserJSON,
                "images": fixtureImagesJSON
            ],[
                "id": 2479407,
                "title": "fixture.title.4",
                "description": "fixture.description.4",
                "animated": false,
                "created_at" : "2016-01-25T08:19:14Z",
                "user": fixtureUserJSON,
                "images": fixtureImagesJSON
            ]
        ]
    }
    
    var fixtureUserJSON: [String: AnyObject] {
        return  [
            "id" : "fixture.id",
            "name" : "fixture.name",
            "username" : "fixture.username",
            "avatar_url" : "fixture.avatar.url"
        ]
    }
    
    var fixtureImagesJSON: [String: AnyObject] {
        return [
            "hidpi": "https://fixture.domain/fixture.image.hidpi.png",
            "normal": "https://fixture.domain/fixture.image.normal.png",
            "teaser": "https://fixture.domain/fixture.image.teaser.png"
        ]
    }
}
