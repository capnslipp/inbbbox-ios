//
//  PageableProviderSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 05/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import PromiseKit
import Mockingjay
import SwiftyJSON

@testable import Inbbbox

class PageableProviderSpec: QuickSpec {
    override func spec() {
        
        var sut: PageableProvider!
        
        beforeEach {
            sut = PageableProvider()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("when init with custom initializer") {
            
            beforeEach {
                sut = PageableProvider(page: 2, pagination: 10)
            }
            
            it("should have properly set page") {
                expect(sut.page).to(equal(2))
            }
            
            it("should have properly set pagination") {
                expect(sut.pagination).to(equal(10))
            }
        }
        
        describe("when init with default initializer") {
            
            beforeEach {
                sut = PageableProvider()
            }
            
            it("should have properly set page") {
                expect(sut.page).to(equal(1))
            }
            
            it("should have properly set pagination") {
                expect(sut.pagination).to(equal(30))
            }
        }
        
        describe("when providing first page with success") {
            
            var result: [ModelMock]?
            
            beforeEach {
                self.stub(everything, builder: json([self.fixtureJSON]))
            }
            
            afterEach {
                result = nil
                self.removeAllStubs()
            }
            
            it("result should be properly returned") {
                let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                promise.then { _result in
                    result = _result
                }.error { _ in fail() }
                
                expect(result).toEventuallyNot(beNil())
                expect(result).toEventually(haveCount(1))
            }
            
            
            context("then next/previous page with unavailable pageable") {
                
                var error: ErrorType!
                
                afterEach {
                    error = nil
                }
                
                it("error should appear") {
                    
                    let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                    
                    promise.then { _ in
                        sut.nextPageFor(ModelMock)
                    }.then { _ -> Void in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is PageableProviderError).toEventually(beTruthy())
                }
                
                it("error should appear") {
                    
                    let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                    
                    promise.then { _ in
                        sut.previousPageFor(ModelMock)
                    }.then { _ -> Void in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is PageableProviderError).toEventually(beTruthy())
                }
            }
            
            context("then next/previous page with available pageable components") {
                
                beforeEach {
                    self.removeAllStubs()
                    self.stub(everything, builder: json([self.fixtureJSON], headers: self.fixtureHeader))
                }
                
                it("results from next page should be properly returned") {
                    
                    let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                    
                    promise.then { _ in
                        sut.nextPageFor(ModelMock)
                    }.then { _result -> Void in
                        result = _result
                    }.error { _ in fail() }
                    
                    expect(result).toEventuallyNot(beNil())
                    expect(result).toEventually(haveCount(1))
                }
                
                it("results from next page should be properly returned") {
                    
                    let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                    
                    promise.then { _ in
                        sut.previousPageFor(ModelMock)
                    }.then { _result -> Void in
                        result = _result
                    }.error { _ in fail() }
                    
                    expect(result).toEventuallyNot(beNil())
                    expect(result).toEventually(haveCount(1))
                }
            }
        }
        
        describe("when providing first page with network error") {
            
            var error: ErrorType!
            
            beforeEach {
                let error = NSError(domain: "", code: 0, message: "")
                self.stub(everything, builder: failure(error))
            }
            
            afterEach {
                error = nil
                self.removeAllStubs()
            }
            
            it("error should appear") {
                let promise: Promise<[ModelMock]?> = sut.firstPageForQueries([QueryMock()], withSerializationKey: nil)
                promise.then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error).toEventuallyNot(beNil())
            }
        }
        
        describe("when providing next/previous page without using firstPage method first") {
            
            var error: ErrorType?
            
            afterEach {
                error = nil
            }
            
            it("error should appear") {
                sut.nextPageFor(ModelMock).then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableProviderError).toEventually(beTruthy())
            }
            
            it("error should appear") {
                sut.previousPageFor(ModelMock).then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableProviderError).toEventually(beTruthy())
            }
        }
    }
}

private struct ModelMock: Mappable {
    
    let identifier: String
    let title: String?
    
    static var map: JSON -> ModelMock {
        return { json in
            return ModelMock(
                identifier: json["identifier"].stringValue,
                title: json["title"].stringValue
            )
        }
    }
}

private extension PageableProviderSpec {
    
    var fixtureJSON: [String: AnyObject] {
        return [
            "identifier" : "fixture.identifier",
            "title" : "fixture.title"
        ]
    }
    
    var fixtureHeader: [String: String] {
        return [
            "Link" :
                "<https://fixture.host/v1/fixture.path?page=1&per_page=100>; rel=\"prev\"," +
                "<https://fixture.host/v1/fixture.path?page=3&per_page=100>; rel=\"next\""
        ]
    }
}

private struct QueryMock: Query {
    let path = "/fixture/path"
    var parameters = Parameters(encoding: .JSON)
    let method = Method.POST
}
