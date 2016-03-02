//
//  ShotDetailsViewModelSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 22/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit
import Dobby

@testable import Inbbbox

class ShotDetailsViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var sut: ShotDetailsViewModel!
        var shot: ShotType!
        var commentsProviderMock: APICommentsProviderMock!
        var commentsRequesterMock: APICommentsRequesterMock!
        
        beforeEach {
            shot = Shot.fixtureShot()
            sut = ShotDetailsViewModel(shot: shot)
            commentsProviderMock = APICommentsProviderMock()
            commentsRequesterMock = APICommentsRequesterMock()
            sut.commentsProvider = commentsProviderMock
            sut.commentsRequester = commentsRequesterMock
            
            commentsProviderMock.provideCommentsForShotStub.on(any()) { _ in
                return Promise{ fulfill, _ in
                    
                    let json = JSONSpecLoader.sharedInstance.fixtureCommentsJSON(withCount: 10)
                    let result = json.map { Comment.map($0) }
                    var resultCommentTypes = [CommentType]()
                    for comment in result {
                        resultCommentTypes.append(comment)
                    }
                    
                    fulfill(resultCommentTypes)
                }
            }
            
            commentsProviderMock.nextPageStub.on(any()) { _ in
                return Promise{ fulfill, _ in
                    
                    let json = JSONSpecLoader.sharedInstance.fixtureCommentsJSON(withCount: 5)
                    let result = json.map { Comment.map($0) }
                    var resultCommentTypes = [CommentType]()
                    for comment in result {
                        resultCommentTypes.append(comment)
                    }
                    
                    fulfill(resultCommentTypes)
                }
            }
            
            commentsRequesterMock.postCommentForShotStub.on(any()) { _, _ in
                return Promise{ fulfill, _ in
                    let result = Comment.fixtureComment()
                    fulfill(result)
                }
            }
            
            commentsRequesterMock.deleteCommentStub.on(any()) { _, _ in
                return Promise()
            }
        }
        
        afterEach {
            shot = nil
            commentsProviderMock = nil
            sut = nil
        }
        
        describe("when newly initialized") {
            
            it("view model should have no comments") {
                expect(sut.commentsCount).to(equal(0))
            }
            
            it("view model should have no items") {
                //NGRTemp: added 2 cause of view model changes
                expect(sut.itemsCount).to(equal(2))
            }
        }
        
        describe("when comments are loaded for the first time") {
            
            var didReceiveResponse: Bool?
            
            beforeEach {
                didReceiveResponse = false
                waitUntil { done in
                    sut.loadComments().then { result -> Void in
                        didReceiveResponse = true
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
            }
            
            afterEach {
                didReceiveResponse = nil
            }
            
            it("commments should be properly downloaded") {
                expect(didReceiveResponse).to(beTruthy())
                expect(didReceiveResponse).toNot(beNil())
            }
            
            it("view model should have correct number of commments") {
                expect(sut.commentsCount).to(equal(10))
            }
            
            it("view model should have correct number of items") {
                //NGRTemp: added 2 cause of view model changes
                expect(sut.itemsCount).to(equal(12))
            }
        }
        
        describe("when comments are loaded with pagination") {
            
            beforeEach {
                waitUntil { done in
                    sut.loadComments().then { result in
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
                
                waitUntil { done in
                    sut.loadComments().then { result in
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
            }
            
            it("view model should have correct number of commments") {
                expect(sut.commentsCount).to(equal(15))
            }
            
            it("view model should have correct number of items") {
                //NGRTemp: added 2 cause of view model changes
                expect(sut.itemsCount).to(equal(17))
            }
        }
        
        describe("when posting comment") {
            
            var didReceiveResponse: Bool?
            
            beforeEach {
                didReceiveResponse = false
                waitUntil { done in
                    sut.postComment("fixture.message").then { result -> Void in
                        didReceiveResponse = true
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
            }
            
            afterEach {
                didReceiveResponse = nil
            }
            
            it("should be correctly added") {
                expect(didReceiveResponse).to(beTruthy())
                expect(didReceiveResponse).toNot(beNil())
            }
        }
        
        describe("when deleting comment") {
            
            var didReceiveResponse: Bool?
            
            beforeEach {
                didReceiveResponse = false
                
                waitUntil { done in
                    sut.loadComments().then { result in
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
                
                waitUntil { done in
                    sut.deleteCommentAtIndex(4).then { result -> Void in
                        didReceiveResponse = true
                        done()
                    }.error { _ in fail("This should not be invoked") }
                }
            }
            
            afterEach {
                didReceiveResponse = nil
            }
            
            it("should be correctly removed") {
                expect(didReceiveResponse).to(beTruthy())
                expect(didReceiveResponse).toNot(beNil())
            }
        }
    }
}
