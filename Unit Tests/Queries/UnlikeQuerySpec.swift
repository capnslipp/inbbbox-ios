//
//  UnlikeQuerySpec.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 17/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class UnlikeQuerySpec: QuickSpec {
    override func spec() {
        
        SharedQuerySpec.performSpecForQuery( { Void -> Query in
            return UnlikeQuery(shotID: "fixture.identifier")
        }) { Void -> QueryExpectation in
            return (method: .DELETE, encoding: .JSON, path: "/shots/fixture.identifier/like")
        }
        
        describe("when newly initialized with shot identifier") {
            
            var sut: UnlikeQuery!
            
            beforeEach {
                sut = UnlikeQuery(shotID: "fixture.identifier")
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have empty parameters") {
                expect(sut.parameters.queryItems).to(beEmpty())
            }
        }
    }
}
