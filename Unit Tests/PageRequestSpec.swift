//
//  PageRequestSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 03/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import Inbbbox

class PageRequestSpec: QuickSpec {
    override func spec() {
        
        var sut: PageRequest!
        
        beforeEach {
            sut = PageRequest(query: MockQuery())
        }

        afterEach {
            sut = nil
            self.removeAllStubs()
        }
        
        context("when sending data with success") {
            
            var didInvokeSuccess: Bool?
            
            beforeEach {
                self.stub(everything, builder: json([]))
            }
            
            afterEach {
                didInvokeSuccess = nil
            }
            
            it("should respond") {
                
                sut.resume().then { _ -> Void in
                    didInvokeSuccess = true
                }.error { _ in fail() }
                
                expect(didInvokeSuccess).toEventuallyNot(beNil())
                expect(didInvokeSuccess!).toEventually(beTruthy())
            }
        }

        context("when sending data with failure") {
            
            var error: ErrorType?
            
            beforeEach {
                let error = NSError(domain: "fixture.domain", code: 0, message: "fixture.message")
                self.stub(everything, builder: failure(error))
            }
            
            afterEach {
                error = nil
            }
            
            it("should respond with proper json") {
                
                sut.resume().then { _ -> Void in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error).toEventuallyNot(beNil())
                expect((error as! NSError).domain).toEventually(equal("fixture.domain"))
            }
        }
    }
}

private struct MockQuery: Query {
    let path = "/fixture/path"
    var parameters = Parameters(encoding: .JSON)
    let method = Method.POST
}
