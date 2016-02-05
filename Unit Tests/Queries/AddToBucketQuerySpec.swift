//
//  AddToBucketQuerySpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class AddToBucketQuerySpec: QuickSpec {
    override func spec() {
        
        SharedQuerySpec.performSpecForQuery( { Void -> Query in
            return AddToBucketQuery(shotID: "123", bucketID: "234")
        }) { Void -> QueryExpectation in
            return (method: .PUT, encoding: .JSON, path: "/buckets/234/shots")
        }
        
        describe("when newly initialized with shot and bucket identifiers") {
            
            var sut: AddToBucketQuery!
            
            beforeEach {
                sut = AddToBucketQuery(shotID: "123", bucketID: "234")
            }

            afterEach {
                sut = nil
            }
            
            it("should have one parameter - shot_id") {
                expect(sut.parameters.body).to(equal(try! NSJSONSerialization.dataWithJSONObject(["shot_id": "123"], options: .PrettyPrinted)))
            }
        }
    }
}
