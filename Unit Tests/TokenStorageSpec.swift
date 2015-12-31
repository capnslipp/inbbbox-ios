//
//  TokenStorageSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 31/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class TokenStorageSpec: QuickSpec {
    override func spec() {
        
        var savedTokenBeforeTestLaunch: String!
        
        beforeSuite {
            savedTokenBeforeTestLaunch = TokenStorage.currentToken
        }
        
        afterSuite {
            TokenStorage.storeToken(savedTokenBeforeTestLaunch)
        }
        
        beforeEach {
            TokenStorage.clear()
        }
        
        describe("when storing token") {
            
            beforeEach {
                TokenStorage.storeToken("fixture.token")
            }
            
            it("token should be properly stored") {
                expect(TokenStorage.currentToken).to(equal("fixture.token"))
            }
            
            context("and clearing storage") {
                
                beforeEach {
                    TokenStorage.clear()
                }
                
                it("token should be nil") {
                    expect(TokenStorage.currentToken).to(equal(""))
                }
            }
        }
    }
}
