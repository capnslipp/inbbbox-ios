//
//  RemoveFromBucketQuerySpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Inbbbox

class RemoveFromBucketQuerySpec: QuickSpec {
    override func spec() {
        
        describe("when newly initialized with shot and bucket identifiers") {
            
            var sut: RemoveFromBucketQuery!
            let fixtureShotID = 123
            let fixtureBucketID = 234
            
            beforeEach {
                sut = RemoveFromBucketQuery(shotID: fixtureShotID, bucketID: fixtureBucketID)
            }
            
            it("should have DELETE method") {
                expect(sut.method.rawValue).to(equal(Method.DELETE.rawValue))
            }
            
            it("should have path with identifier") {
                expect(sut.path).to(equal("/buckets/234/shots"))
            }
            
            it("should have dribbble service") {
                expect(sut.service is DribbbleNetworkService).to(beTrue())
            }
            
            it("should have parameters with JSON encoding") {
                expect(sut.parameters.encoding).to(equal(Parameters.Encoding.JSON))
            }
            
            it("should have one parameter - shot_id") {
                expect(sut.parameters.body).to(equal(try! NSJSONSerialization.dataWithJSONObject(["shot_id":fixtureShotID], options: .PrettyPrinted)))
            }
            
        }
        
    }
}

