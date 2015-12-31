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

        it("when newly created, should have corrent service") {
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
    }
}
