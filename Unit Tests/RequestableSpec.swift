//
//  RequestableSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 03/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class RequestableSpec: QuickSpec {
    override func spec() {
        
        var sut: RequestableMock!
        
        describe("when initializaing request to be used as POST") {
            
            beforeEach {
                sut = RequestableMock(encoding: .JSON)
            }
            
            afterEach {
                sut = nil
            }
            
            it("request should have properly set http header") {
                let HTTPHeaderFields = [
                    "Content-Type" : "application/json",
                    "fixture.http.header.field" : "fixture.header"
                ]
                expect(sut.foundationRequest.allHTTPHeaderFields).to(equal(HTTPHeaderFields))
            }
            
            it("request should have url") {
                expect(sut.foundationRequest.URL).toNot(beNil())
            }
            
            it("request should have proper url") {
                let expectedURL = NSURL(string: "https://fixture.host/v1/query.fixture/path")
                expect(sut.foundationRequest.URL).to(equal(expectedURL))
            }
            
            it("request body should be properly set") {
                let expectedData = try! JSONSerialization.data(withJSONObject: ["fixture.key" : "fixture.value"], options: .prettyPrinted)
                expect(sut.foundationRequest.HTTPBody).to(equal(expectedData))
            }
        }
        
        describe("when initializaing request to be used as GET") {
            
            beforeEach {
                sut = RequestableMock(encoding: .URL)
            }
            
            afterEach {
                sut = nil
            }
            
            it("request should have properly set http header") {
                let HTTPHeaderFields = [
                    "fixture.http.header.field" : "fixture.header"
                ]
                expect(sut.foundationRequest.allHTTPHeaderFields).to(equal(HTTPHeaderFields))
            }
            
            it("request should have url") {
                expect(sut.foundationRequest.URL).toNot(beNil())
            }
            
            it("request should have proper url") {
                let expectedURL = NSURL(string: "https://fixture.host/v1/query.fixture/path?fixture.key=fixture.value")
                expect(sut.foundationRequest.URL).to(equal(expectedURL))
            }
            
            it("request body should be nil") {
                expect(sut.foundationRequest.HTTPBody).to(beNil())
            }
        }
    }
}

private struct RequestableMock: Requestable {
    
    let query: Query = QueryMock()
    
    init(encoding: Parameters.Encoding) {
        query.parameters = Parameters(encoding: encoding)
        query.parameters["fixture.key"] = "fixture.value"
    }
}

private struct QueryMock: Query {
    
    let path = "/query.fixture/path"
    var parameters = Parameters(encoding: .JSON)
    let method = Method.POST
    
    var service: SecureNetworkService {
        return ServiceMock()
    }
}

private struct ServiceMock: SecureNetworkService {
    
    let scheme = "https"
    let host = "fixture.host"
    let version = "/v1"
    
    func authorizeRequest(_ request: NSMutableURLRequest) {
        request.setValue("fixture.header", forHTTPHeaderField: "fixture.http.header.field")
    }
}
