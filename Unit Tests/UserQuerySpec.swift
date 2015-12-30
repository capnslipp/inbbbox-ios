//
//  UserQuerySpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 30/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class UserQuerySpec: QuickSpec {
    override func spec() {
        
        describe("when newly initialized with identifier") {
            
            var sut: UserQuery!
            
            beforeEach {
                sut = UserQuery(identifier: "fixture.identifier")
            }
            
            it("should have GET method") {
                expect(sut.method.rawValue).to(equal(Method.GET.rawValue))
            }
            
            it("should have path with identifier") {
                expect(sut.path).to(equal("/users/fixture.identifier"))
            }
            
            it("should have dribbble service") {
                expect(sut.service is DribbbleNetworkService).to(beTrue())
            }
            
            it("should have parameters with URL encoding") {
                expect(sut.parameters.encoding).to(equal(Parameters.Encoding.URL))
            }
            
            it("should have empty parameters") {
                expect(sut.parameters.queryItems).to(beEmpty())
            }
        }
        
        describe("when newly initialized") {
            
            var sut: UserQuery!
            
            beforeEach {
                sut = UserQuery()
            }
            
            it("should have GET method") {
                expect(sut.method.rawValue).to(equal(Method.GET.rawValue))
            }
            
            it("should have path with identifier") {
                expect(sut.path).to(equal("/user"))
            }
            
            it("should have dribbble service") {
                expect(sut.service is DribbbleNetworkService).to(beTrue())
            }
            
            it("should have parameters with URL encoding") {
                expect(sut.parameters.encoding).to(equal(Parameters.Encoding.URL))
            }
            
            it("should have empty parameters") {
                expect(sut.parameters.queryItems).to(beEmpty())
            }
        }
    }
}
