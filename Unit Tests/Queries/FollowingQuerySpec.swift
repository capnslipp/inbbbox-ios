//
//  FollowingQuerySpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 26/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Inbbbox

class FollowingQuerySpec: QuickSpec {
    override func spec() {
        
        var sut: FollowingQuery!
        
        afterEach {
            sut = nil
        }
        
        describe("when newly initialized with identifier") {
            
            SharedQuerySpec.performSpecForQuery( { Void -> Query in
                return FollowingQuery()
            }) { Void -> QueryExpectation in
                return (method: .GET, encoding: .URL, path: "/user/following")
            }
            
            beforeEach {
                sut = FollowingQuery()
            }
            
            it("should have empty parameters") {
                expect(sut.parameters.queryItems).to(beEmpty())
            }
        }
        
        describe("when newly initialized") {
            
            SharedQuerySpec.performSpecForQuery( { Void -> Query in
                return FollowingQuery(usersFollowedByUser: self.fixtureUser)
            }) { Void -> QueryExpectation in
                return (method: .GET, encoding: .URL, path: "/users/fixture.username/following")
            }
            
            beforeEach {
                sut = FollowingQuery(usersFollowedByUser: self.fixtureUser)
            }
            
            it("should have empty parameters") {
                expect(sut.parameters.queryItems).to(beEmpty())
            }
        }
    }
}

private extension FollowingQuerySpec {
    
    var fixtureUser: User {
        
        let dictionary = [
            "id" : "fixture.id",
            "name" : "fixture.name",
            "username" : "fixture.username",
            "avatar_url" : "fixture.avatar.url"
        ]
        return User(json: JSON(dictionary))
    }
}
