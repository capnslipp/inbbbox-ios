//
//  BucketsProviderSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit

@testable import Inbbbox

class BucketsProviderSpec: QuickSpec {
    override func spec() {
        
        var sut: BucketsProvider!
        
        beforeEach {
            sut = BucketsProvider()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("when using next/previous page without specyfing provide method") {
            
            var error: ErrorType?
            
            afterEach {
                error = nil
            }
            
            it("error should appear") {
                sut.nextPage().then { _ -> Void in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableError).toEventually(beTruthy())
            }
            
            it("error should appear") {
                sut.previousPage().then { _ -> Void in
                    fail()
                }.error { _error in
                    error = _error
                }
                
                expect(error is PageableError).toEventually(beTruthy())
            }
        }
        
        describe("when providing my buckets") {
            
            context("and token doesn't exist") {
                
                var error: ErrorType?
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                afterEach {
                    error = nil
                }
                
                it("error should appear") {
                    sut.provideMyBuckets().then { _ -> Void in
                        fail()
                    }.error { _error in
                        error = _error
                    }
                    
                    expect(error is AuthorizableError).toEventually(beTruthy())
                }
            }
            
            context("and token does exist") {
                
                var didInvokePromise: Bool?
                
                beforeEach {
                    TokenStorage.storeToken("fixture.token")
                }
                
                afterEach {
                    didInvokePromise = nil
                }
                
                fit("error should appear") {
                    sut.provideMyBuckets().then { _ -> Void in
                        didInvokePromise = true
                    }.error { _ in fail() }
                    
                    expect(didInvokePromise).toEventually(beTruthy())
                }
            }
        }
    }
}
