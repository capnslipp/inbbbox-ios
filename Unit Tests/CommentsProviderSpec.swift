//
//  CommentsProviderSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 10/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit
import Mockingjay

@testable import Inbbbox

class CommentsProviderSpec: QuickSpec {
    override func spec() {
        
        var comments: [Comment]?
        var sut: CommentsProviderMock!
        
        beforeEach {
            sut = CommentsProviderMock()
        }
        
        afterEach {
            sut = nil
            comments = nil
        }
        
        describe("when providing comments for shot") {
            
            it("comments should be properly returned") {
                sut.provideCommentsForShot(Shot.fixtureShot()).then { _comments -> Void in
                    comments = _comments
                }.error { _ in fail() }
                
                expect(comments).toNotEventually(beNil())
                expect(comments).toEventually(haveCount(3))
            }

        }
        
        describe("when providing comments from next page") {
            
            it("comments should be properly returned") {
                sut.nextPage().then { _comments -> Void in
                    comments = _comments
                }.error { _ in fail() }
                
                expect(comments).toNotEventually(beNil())
                expect(comments).toEventually(haveCount(3))
            }
        }
        
        describe("when providing comments from previous page") {
            
            it("comments should be properly returned") {
                sut.previousPage().then { _comments -> Void in
                    comments = _comments
                }.error { _ in fail() }
                
                expect(comments).toNotEventually(beNil())
                expect(comments).toEventually(haveCount(3))
            }
        }
        
        describe("when posting comment") {
            
            var error: ErrorType?
            var comment: Comment?
            
            beforeEach {
                error = nil
                comment = nil
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
            
            var error: ErrorType?
            var comment: Comment?
            
            beforeEach {
                error = nil
                comment = nil
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
            
            var error: ErrorType?
            var didInvokePromise: Bool?
            
            beforeEach {
                error = nil
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
                    
                    expect(error is VerifiableError).toNotEventually(beTruthy())
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
                
                it("comment should be posted") {
                    sut.deleteComment(Comment.fixtureComment(), forShot: Shot.fixtureShot()).then { _ in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
    }
}

//Explanation: Create CommentsProviderMock to override methods from PageableProvider.
private class CommentsProviderMock: CommentsProvider {
    
    override func firstPageForQueries<T: Mappable>(queries: [Query], withSerializationKey key: String?) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func nextPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func previousPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    func mockResult<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, _ in
            
            let json = JSONSpecLoader.sharedInstance.fixtureCommentsJSON(withCount: 3)
            let result = json.map { T.map($0) }
            
            fulfill(result)
        }
    }
}

private extension CommentsProviderSpec {
    
    var fixtureJSON: [String: AnyObject] {
        return JSONSpecLoader.sharedInstance.jsonWithResourceName("Comment").dictionaryObject!
    }
}
