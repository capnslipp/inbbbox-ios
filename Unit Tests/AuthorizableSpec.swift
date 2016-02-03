//
//  AuthorizableSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 03/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Inbbbox

class AuthorizableSpec: QuickSpec {
    override func spec() {
        
        var sut: MockAuthorizable!
        var savedTokenBeforeTestLaunch: String!
        var didInvokePromise: Bool!
        var error: ErrorType?
        
        beforeSuite {
            savedTokenBeforeTestLaunch = TokenStorage.currentToken
        }
        
        afterSuite {
            if let token = savedTokenBeforeTestLaunch {
                TokenStorage.storeToken(token)
            }
            
        }
        
        beforeEach {
            sut = MockAuthorizable()
        }
        
        afterEach {
            sut = nil
            didInvokePromise = false
            error = nil
        }
        
        describe("when token isn't stored") {
            
            beforeEach {
                TokenStorage.clear()
            }
            
            context("and authorization isn't needed") {
                
                it("authorization check should pass") {
                    
                    waitUntil { done in
                        sut.authorizeIfNeeded(false).then { _ -> Void in
                            didInvokePromise = true
                            done()
                        }.error { _ in fail() }
                    }
                    
                    expect(didInvokePromise).to(beTruthy())
                    expect(error).to(beNil())
                }
            }
            
            context("and authorization is needed") {

                it("authorization check should throw error") {
                    
                    waitUntil { done in
                        sut.authorizeIfNeeded(true).then { _ -> Void in
                            fail()
                        }.error { _error in
                            didInvokePromise = true
                            error = _error
                            done()
                        }
                    }
                    
                    expect(didInvokePromise).to(beTruthy())
                    expect(error is AuthorizableError).to(beTruthy())
                }
            }
        }
        
        describe("when token exists") {
            
            beforeEach {
                TokenStorage.storeToken("fixture.token")
            }
            
            context("and authorization isn't needed") {
                
                it("authorization check should pass") {
                    
                    waitUntil { done in
                        sut.authorizeIfNeeded(false).then { _ -> Void in
                            didInvokePromise = true
                            done()
                        }.error { _ in fail() }
                    }
                    
                    expect(didInvokePromise).to(beTruthy())
                    expect(error).to(beNil())
                }
            }
            
            context("and authorization is needed") {
                
                it("authorization check should throw error") {
                    
                    waitUntil { done in
                        sut.authorizeIfNeeded(true).then { _ -> Void in
                            didInvokePromise = true
                            done()
                        }.error { _ in fail() }
                    }
                    
                    expect(didInvokePromise).to(beTruthy())
                    expect(error).to(beNil())
                }
            }
        }
    }
}

private struct MockAuthorizable: Authorizable {}
