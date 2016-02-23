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
                expect(sut.itemsCount).to(equal(0))
            }
            
            it("compact variant of header can't be displayed") {
                expect(sut.compactVariantCanBeDisplayed).to(beFalsy())
            }
            
            describe("view data for header") {
                
                var viewDataForHeader: ShotDetailsViewModel.HeaderViewData?
                
                beforeEach {
                    waitUntil { done in
                        sut.viewDataForHeader{ _, viewData in
                            viewDataForHeader = viewData!
                            done()
                        }
                    }
                }
                
                it("should have correct description") {
                    expect(viewDataForHeader!.description).to(equal(shot.htmlDescription))
                }
                
                it("should have correct title") {
                    expect(viewDataForHeader!.title).to(equal(shot.title))
                }
                
                it("should have correct author") {
                    expect(viewDataForHeader!.author).to(equal(shot.user.name ?? shot.user.username))
                }
                
                it("should have correct client") {
                    expect(viewDataForHeader!.client).to(equal(shot.team?.name))
                }
                
                it("should have correct shotInfo") {
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = .MediumStyle
                    formatter.locale = NSLocale(localeIdentifier: "en_US")
                    
                    expect(viewDataForHeader!.shotInfo).to(equal(formatter.stringFromDate(shot.createdAt)))
                }
                
                it("should have correct shot url") {
                    expect(viewDataForHeader!.shot).to(equal(shot.shotImage.normalURL.absoluteString))
                }
                
                it("should have correct avatar url") {
                    expect(viewDataForHeader!.avatar).to(equal(shot.user.avatarString))
                }
            }
        }
        
        describe("when comments are loaded for the first time") {
            
            var responseResult: String!
            let successResponse = "success"
            
            beforeEach {
                
                waitUntil { done in
                    sut.loadComments { result in
                        switch result {
                        case .Success:
                            responseResult = successResponse
                        case .Error(_):
                            fail("This should not be invoked")
                        }
                        done()
                    }
                }
            }
            
            it("commments should be properly downloaded") {
                expect(responseResult).to(equal(successResponse))
            }
            
            it("view model should have correct number of commments") {
                expect(sut.commentsCount).to(equal(10))
            }
            
            it("view model should have correct number of items") {
                expect(sut.itemsCount).to(equal(11))
            }
            
            describe("any comment") {
                var viewDataForCommentCell: ShotDetailsViewModel.DetailsCollectionViewCellViewData?
                
                beforeEach {
                    viewDataForCommentCell = sut.viewDataForCellAtIndex(0)
                }
                
                it("should have correct author") {
                    expect(viewDataForCommentCell!.author).to(equal(Comment.fixtureComment().user.name))
                }
                
                it("should have correct comment") {
                    expect(viewDataForCommentCell!.comment).to(equal(Comment.fixtureComment().body))
                }
                
                it("should have correct avatar") {
                    expect(viewDataForCommentCell!.avatar).to(equal(Comment.fixtureComment().user.avatarString))
                }
                
                it("should have correct time") {
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = .MediumStyle
                    formatter.locale = NSLocale(localeIdentifier: "en_US")
                    formatter.timeStyle = .ShortStyle
                    
                    expect(viewDataForCommentCell!.time).to(equal(formatter.stringFromDate(Comment.fixtureComment().createdAt)))
                }
            }
        }
        
        describe("when comments are loaded with pagination") {
            beforeEach {
                
                waitUntil { done in
                    sut.loadComments { result in
                        switch result {
                        case .Success:
                            break
                        case .Error(_):
                            fail("This should not be invoked")
                        }
                        done()
                    }
                }
                
                waitUntil { done in
                    sut.loadComments { result in
                        switch result {
                        case .Success:
                            break
                        case .Error(_):
                            fail("This should not be invoked")
                        }
                        done()
                    }
                }
            }
            
            it("view model should have correct number of commments") {
                expect(sut.commentsCount).to(equal(15))
            }
            
            it("view model should have correct number of items") {
                expect(sut.itemsCount).to(equal(15))
            }
        }
        
        describe("when posting comment") {
            var responseResult: String!
            let successResponse = "success"
            
            beforeEach {
                waitUntil { done in
                    sut.postComment("fixture.message") { result -> Void in
                        switch result {
                        case .Success:
                            responseResult = successResponse
                        case .Error(_):
                            fail("This should not be invoked")
                        }
                        done()
                    }
                }
            }
            
            it("should be correctly added") {
                expect(responseResult).to(equal(successResponse))
            }
        }
        
        describe("when tapping `like shot`") {
            
            var responseResult: String!
            let successResponse = "success"
            
            beforeEach {
                waitUntil { done in
                    sut.userDidTapLikeButton(true) { result -> Void in
                        switch result {
                        case .Success:
                            responseResult = successResponse
                        case .Error(_):
                            fail("This should not be invoked")
                        }
                        done()
                    }
                }
            }
            
            it("shot should be correctly liked") {
                expect(responseResult).to(equal(successResponse))
            }
        }
    }
}


