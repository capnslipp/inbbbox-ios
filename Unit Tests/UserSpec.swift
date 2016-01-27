//
//  UserSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 05/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Inbbbox

class UserSpec: QuickSpec {
    override func spec() {
        
        it("should support secure coding") {
            expect(User.supportsSecureCoding()).to(beTruthy())
        }
        
        var sut: User!
        
        afterEach {
            sut = nil
        }
        
        describe("when mapping user") {
            
            beforeEach {
                sut = User.fixtureUser()
            }
            
            it("user should exist") {
                expect(sut).toNot(beNil())
            }
            
            it("user's username should be properly mapped") {
                expect(sut.username).to(equal("fixture.username"))
            }
            
            it("user's name should be properly mapped") {
                expect(sut.name).to(equal("fixture.name"))
            }
            
            it("user's avatar url should be properly mapped") {
                expect(sut.avatarString).to(equal("fixture.avatar.url"))
            }
            
            it("user's id should be properly mapped") {
                expect(sut.identifier).to(equal("fixture.id"))
            }
        }
        
        describe("when encoding user") {
            
            var data: NSData!
            
            beforeEach {
                sut = User.fixtureUser()
                data = NSKeyedArchiver.archivedDataWithRootObject(sut)
            }
            
            it("data should not be nil") {
                expect(data).toNot(beNil())
            }
            
            context("and decoding data") {
                
                var decodedUser: User?
                
                beforeEach {
                    decodedUser = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
                }
                
                it("user should not be nil") {
                    expect(decodedUser).toNot(beNil())
                }
                
                it("user's username should be properly decoded") {
                    expect(sut.username).to(equal(decodedUser!.username))
                }
                
                it("user's name should be properly decoded") {
                    expect(sut.name).to(equal(decodedUser!.name))
                }
                
                it("user's avatar url should be properly decoded") {
                    expect(sut.avatarString).to(equal(decodedUser!.avatarString))
                }
                
                it("user's id should be properly decoded") {
                    expect(sut.identifier).to(equal(decodedUser!.identifier))
                }
            }
        }
    }
}
