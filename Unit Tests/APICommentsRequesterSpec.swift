//
//  APICommentsRequesterSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit
import Mockingjay

@testable import Inbbbox

class APICommentsRequesterSpec: QuickSpec {
    override func spec() {
        
        var sut: APICommentsRequester!
        var error: ErrorType?
        var comment: CommentType?
        
        beforeEach {
            sut = APICommentsRequester()
        }
        
        afterEach {
            sut = nil
            error = nil
            comment = nil
        }
        
        describe("when posting comment") {

            afterEach {
                TokenStorage.clear()
                UserStorage.clear()
            }
            
            context("when token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should occur") {
                    sut.postCommentForShot(Shot.fixtureShot(), withText: "fixture.text").then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists, but account type is wrong") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.User))
                    TokenStorage.storeToken("fixture.token")
                }
                
                it("error should occur") {
                    sut.postCommentForShot(Shot.fixtureShot(), withText: "fixture.text").then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists and account type is correct") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.Player))
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json(self.fixtureJSON))
                }
                
                afterEach {
                    self.removeAllStubs()
                }
                
                it("comment should be posted") {
                    sut.postCommentForShot(Shot.fixtureShot(), withText: "fixture.text").then { _comment in
                        comment = _comment
                    }.error { _ in fail() }
                    
                    expect(comment).toNotEventually(beNil())
                }
            }
        }
        
        describe("when updating comment") {
            
            afterEach {
                TokenStorage.clear()
                UserStorage.clear()
            }
            
            context("when token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should occur") {
                    sut.updateComment(Comment.fixtureComment(), forShot: Shot.fixtureShot(), withText: "fixture.text").then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists, but account type is wrong") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.User))
                    TokenStorage.storeToken("fixture.token")
                }
                
                it("error should occur") {
                    sut.updateComment(Comment.fixtureComment(), forShot: Shot.fixtureShot(), withText: "fixture.text").then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists and account type is correct") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.Player))
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json(self.fixtureJSON))
                }
                
                afterEach {
                    self.removeAllStubs()
                }
                
                it("comment should be posted") {
                    sut.updateComment(Comment.fixtureComment(), forShot: Shot.fixtureShot(), withText: "fixture.text").then { _comment in
                        comment = _comment
                    }.error { _ in fail() }
                    
                    expect(comment).toNotEventually(beNil())
                }
            }
        }
        
        describe("when deleting comment") {
            
            var didInvokePromise: Bool?
            
            beforeEach {
                didInvokePromise = nil
            }
            
            afterEach {
                TokenStorage.clear()
                UserStorage.clear()
            }
            
            context("when token does not exist") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("error should occur") {
                    sut.deleteComment(Comment.fixtureComment(), forShot: Shot.fixtureShot()).then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists, but account type is wrong") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.User))
                    TokenStorage.storeToken("fixture.token")
                }
                
                it("error should occur") {
                    sut.deleteComment(Comment.fixtureComment(), forShot: Shot.fixtureShot()).then { _ in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is VerifiableError).toEventually(beTruthy())
                }
            }
            
            context("when token exists and account type is correct") {
                
                beforeEach {
                    UserStorage.storeUser(User.fixtureUserForAccountType(.Player))
                    TokenStorage.storeToken("fixture.token")
                    self.stub(everything, builder: json(self.fixtureJSON))
                }
                
                afterEach {
                    self.removeAllStubs()
                }
                
//                it("comment should be posted") {
//                    sut.deleteComment(Comment.fixtureComment(), forShot: Shot.fixtureShot()).then { _ in
//                        didInvokePromise = true
//                    }.error { _ in fail() }
//                    
//                    expect(didInvokePromise).toEventually(beTruthy(), timeout: 3)
//                }
            }
        }
    }
}

private extension APICommentsRequesterSpec {
    
    var fixtureJSON: [String: AnyObject] {
        return JSONSpecLoader.sharedInstance.jsonWithResourceName("Comment").dictionaryObject!
    }
}
