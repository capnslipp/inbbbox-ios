//
//  OAuthViewModelSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 31/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import WebKit.WKNavigationDelegate
import PromiseKit
import Mockingjay

@testable import Inbbbox

class OAuthViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var service: MockLoginService!
        var sut: OAuthViewModel!
        
        beforeEach {
            service = MockLoginService()
            sut = OAuthViewModel(oAuthAuthorizableService: service)
        }
        
        afterEach {
            service = nil
            sut = nil
        }

        it("when newly created, should have correct service") {
            expect(service == sut.service).to(beTruthy())
        }
        
        describe("when checking action for policy") {
            
            var policy: WKNavigationActionPolicy!
            
            context("with redirection url request") {
                
                beforeEach {
                    let request = NSURLRequest(URL: NSURL(string: "http://mock.redirection.url")!)
                    policy = sut.actionPolicyForRequest(request)
                }
                
                it("policy should be set to Cancel") {
                    expect(policy).to(equal(WKNavigationActionPolicy.Cancel))
                }
            }
            
            context("with non-redirection url request") {
                
                beforeEach {
                    let request = NSURLRequest(URL: NSURL(string: "http://anyurl")!)
                    policy = sut.actionPolicyForRequest(request)
                }
                
                it("policy should be set to Allow") {
                    expect(policy).to(equal(WKNavigationActionPolicy.Allow))
                }
            }
        }
        
        describe("when starting authentication proccess") {
            
            var didInvokeLoadRequestReverseClosure = false
            
            beforeEach {
                sut.loadRequestReverseClosure = { _ in
                    didInvokeLoadRequestReverseClosure = true
                }
                sut.startAuthentication()
            }
            
            it("should invoke load request reverse closure") {
                expect(didInvokeLoadRequestReverseClosure).to(beTruthy())
            }
        }
        
        describe("when starting authentication proccess and stopping it without reason") {
            
            it("error should be unknown error") {
                
                var error: ErrorType!
                
                func startAuthentication() throws {
                    
                    var error: ErrorType!
                    
                    firstly {
                        after(0.1)
                    }.then {
                        sut.stopAuthentication()
                    }
                    
                    waitUntil { done in
                        firstly {
                            sut.startAuthentication()
                        }.then { _ -> Void in
                            fail("This closure should not be invoked")
                        }.error { _error in
                            error = _error
                            done()
                        }
                    }

                    throw error
                }
                
                expect{ try startAuthentication() }.to(throwError(AuthenticatorError.UnknownError))
            }
        }
        
        describe("when starting authentication proccess and stopping it with reason") {
            
            it("error should contains reason of canceling") {
                
                var error: ErrorType!
                
                func startAuthentication() throws {
                    
                    var error: ErrorType!
                    
                    firstly {
                        after(0.1)
                    }.then {
                        sut.stopAuthentication(withError: AuthenticatorError.AuthenticationDidCancel)
                    }
                    
                    waitUntil { done in
                        firstly {
                            sut.startAuthentication()
                        }.then { _ -> Void in
                            fail("This closure should not be invoked")
                        }.error { _error in
                            error = _error
                            done()
                        }
                    }

                    throw error
                }
                
                expect{ try startAuthentication() }.to(throwError(AuthenticatorError.AuthenticationDidCancel))
            }
        }
        
        describe("and request matches redirect uri") {
            
            context("and contains code") {
                
                beforeEach {
                    sut.loadRequestReverseClosure = { _ in
                        let request = NSURLRequest(URL: NSURL(string: "http://mock.redirection.url?code=fixture.code")!)
                        sut.actionPolicyForRequest(request)
                    }
                    sut.startAuthentication()
                }
                
                context("and response with access token parameter") {
                    
                    beforeEach {
                        let body = ["access_token" : "fixture.access.token"]
                        self.stub(everything, builder: json(body))
                    }
                    
                    afterEach {
                        self.removeAllStubs()
                    }
                    
                    it("access token should be properly returned") {
                        
                        var accessToken = ""
                        
                        waitUntil { done in
                            firstly {
                                sut.startAuthentication()
                            }.then { _accessToken -> Void in
                                accessToken = _accessToken
                                done()
                            }.error { error in
                                fail("This closure should not be invoked")
                            }
                        }
                        
                        expect(accessToken).toEventually(equal("fixture.access.token"))
                    }
                }
                
                context("and response without access token parameter") {
                    
                    beforeEach {
                        let body = ["param" : "fixture.param"]
                        self.stub(everything, builder: json(body))
                    }
                    
                    afterEach {
                        self.removeAllStubs()
                    }
                    
                    it("should throw Access Token Missing error") {
                        
                        func startAuthentication() throws {
                            
                            var error: ErrorType!
                            
                            waitUntil { done in
                                firstly {
                                    sut.startAuthentication()
                                }.then { _ -> Void in
                                    fail("This closure should not be invoked")
                                }.error { _error in
                                    error = _error
                                    done()
                                }
                            }
                            
                            throw error
                        }
                        
                        expect{ try startAuthentication() }.to(throwError(AuthenticatorError.AccessTokenMissing))
                    }
                }
                
                context("and error will occur") {
                    
                    beforeEach {
                        let error = NSError(domain: "fixture.domain", code: 100, message: "fixture.message")
                        self.stub(everything, builder: failure(error))
                    }
                    
                    afterEach {
                        self.removeAllStubs()
                    }
                    
                    it("should throw Access Token Missing error") {
                        
                        func startAuthentication() throws {
                            
                            var error: ErrorType!
                            
                            waitUntil { done in
                                firstly {
                                    sut.startAuthentication()
                                }.then { _ -> Void in
                                    fail("This closure should not be invoked")
                                }.error { _error in
                                    error = _error
                                    done()
                                }
                            }
                            
                            throw error as! URLError
                        }
                        
                        expect{ try startAuthentication() }.to(throwError { (promiseError: URLError) in
                            
                            
                            func errorFromUPromiseError(error: URLError) -> NSError? {

                                switch error {
                                case .UnderlyingCocoaError(_, _, _, let underlayingError):
                                    return underlayingError 
                                default:
                                    return nil
                                }
                            }
                            
                            guard let error = errorFromUPromiseError(promiseError) else {
                                fail("error should not be nil"); return
                            }

                            expect(error.domain).to(equal("fixture.domain"))
                        })
                    }
                }
            }
            
            context("and doesn't contain code") {
                
                beforeEach {
                    sut.loadRequestReverseClosure = { _ in
                        let request = NSURLRequest(URL: NSURL(string: "http://mock.redirection.url?param=fixture")!)
                        sut.actionPolicyForRequest(request)
                    }
                }
                
                it("should throw Auth Token Missing error") {
                    
                    func startAuthentication() throws {
                        
                        var error: ErrorType!
                        
                        waitUntil { done in
                            firstly {
                                sut.startAuthentication()
                            }.then { _ -> Void in
                                fail("This closure should not be invoked")
                            }.error { _error in
                                error = _error
                                done()
                            }
                        }
                        
                        throw error
                    }
                    
                    expect{ try startAuthentication() }.to(throwError(AuthenticatorError.AuthTokenMissing))
                }
            }
        }
    }
}
