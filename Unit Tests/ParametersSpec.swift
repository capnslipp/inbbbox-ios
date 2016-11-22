//
//  ParametersSpec.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 15/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ParametersSpec: QuickSpec {
    override func spec() {
        
        describe("when newly initialized") {
            
            var sut = Parameters(encoding: .URL)
            
            context("with URL encoding") {
                beforeEach {
                    sut = Parameters(encoding: .URL)
                }
                
                it("should not be nil") {
                    expect(sut).notTo(beNil())
                }
                
                it("should have URL encoding") {
                    expect(sut.encoding).to(equal(Parameters.Encoding.URL))
                }
                
                it("should have empty query items") {
                    expect(sut.queryItems).to(beEmpty())
                }
                
                it("should have nil body") {
                    expect(sut.body).to(beNil())
                }
                
                context("when storing values") {
                    beforeEach {
                        sut["fixture.key.1"] = "fixture.value.1"
                        sut["fixture.key.2"] = 123
                    }
                
                    it("should return correct value") {
                        expect(sut["fixture.key.1"] as? String).to(equal("fixture.value.1"))
                    }
                    
                    it("should return correct query items") {
                        expect(sut["fixture.key.2"] as? Int).to(equal(123))
                    }
                    
                    context("reading query items") {
                        
                        var queryItems: [NSURLQueryItem]!
                        let expectedQueryItems: [NSURLQueryItem]! = [
                            NSURLQueryItem(name: "fixture.key.1", value: "fixture.value.1"),
                            NSURLQueryItem(name: "fixture.key.2", value: "123")
                        ]
                        
                        beforeEach {
                            queryItems = sut.queryItems
                        }
                        
                        it("should have correct query items") {
                            expect(queryItems).to(contain(expectedQueryItems.first!))
                            expect(queryItems).to(contain(expectedQueryItems.last!))
                        }
                    }
                    
                    context("then clearing them") {
                        it("should return nil instead of string") {
                            sut["fixture.key.1"] = nil
                            expect(sut["fixture.key.1"]).to(beNil())
                            expect(sut["fixture.key.2"] as? Int).to(equal(123))
                        }
                        
                        it("should return nil instead of array") {
                            sut["fixture.key.2"] = nil
                            expect(sut["fixture.key.1"] as? String).to(equal("fixture.value.1"))
                            expect(sut["fixture.key.2"]).to(beNil())
                        }
                    }
                    
                }
                
            }
            
            context("with JSON encoding") {
                beforeEach {
                    sut = Parameters(encoding: .JSON)
                }
                
                it("should not be nil") {
                    expect(sut).notTo(beNil())
                }
                
                it("should have JSON encoding") {
                    expect(sut.encoding).to(equal(Parameters.Encoding.JSON))
                }
                
                it("should have empty query items") {
                    expect(sut.queryItems).to(beEmpty())
                }
                
                it("should have body") {
                    expect(sut.body).notTo(beNil())
                }
                
                context("when storing values") {
                    beforeEach {
                        sut["fixture.key.1"] = "fixture.value.1"
                        sut["fixture.key.2"] = 123
                    }
                    
                    it("should have correct JSON by serializing body") {
                        let json = try! JSONSerialization.JSONObjectWithData(sut.body!, options: .AllowFragments) as! [String: AnyObject]
                        let expectedJSON = [
                            "fixture.key.1": "fixture.value.1" as AnyObject,
                            "fixture.key.2": 123 as AnyObject
                        ] as [String: AnyObject]
                        
                        expect(json == expectedJSON).to(beTrue())
                    }
                }
            }
        }
    }
}

private func ==(lhs: [String: AnyObject], rhs: [String: AnyObject]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
