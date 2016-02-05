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
        
        describe("when providing first page with success") {
            
            var result: [MockModel]?
            
            beforeEach {
                 self.stub(everything, builder: json([self.fixtureJSON]))
            }
            
            afterEach {
                result = nil
                self.removeAllStubs()
            }
            
            it("result should be properly returned") {
                let promise: Promise<[MockModel]?> = sut.firstPageForQueries([MockQuery()])
                promise.then { _result in
                    result = _result
                }.error { _ in fail() }
                
                expect(result).toEventuallyNot(beNil())
                expect(result).toEventually(haveCount(1))
            }
            
            context("then next/previous page") {
                
                var didInvokePromise: Bool!
                
                beforeEach {
                    let _: Promise<[MockModel]?> = sut.firstPageForQueries([MockQuery()])
                }
                
                afterEach {
                    didInvokePromise = nil
                }
                
                it("results from next page should be properly returned") {
                    sut.nextPageFor(MockModel).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
                
                
                it("results from previous page should be properly returned") {
                    sut.nextPageFor(MockModel).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
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
                let promise: Promise<[MockModel]?> = sut.firstPageForQueries([MockQuery()])
                promise.then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error).toEventuallyNot(beNil())
            }
        }
        
        describe("when providing next/previous page without using firstPage method first") {
            
            var error: ErrorType!
            
            afterEach {
                error = nil
            }
            
            it("error should appear") {
                sut.nextPageFor(MockModel).then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableProviderError).toEventually(beTruthy())
            }
            
            it("error should appear") {
                sut.previousPageFor(MockModel).then { _ in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableProviderError).toEventually(beTruthy())
            }
        }
    }
}

private struct MockModel: Mappable {
    
    let identifier: String
    let title: String?
    
    static var map: JSON -> MockModel {
        return { json in
            return MockModel(
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
}

private struct MockQuery: Query {
    let path = "/fixture/path"
    var parameters = Parameters(encoding: .JSON)
    let method = Method.POST
}
