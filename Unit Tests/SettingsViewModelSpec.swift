//
//  SettingsViewModelSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 30/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class SettingsViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var sut: SettingsViewModel!
        
        describe("when newly created") {
            
            beforeEach {
                sut = SettingsViewModel(delegate: SettingsViewController())
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have account title") {
                expect(sut.title).to(equal("Account"))
            }
            
            it("should have 2 sections") {
                expect(sut.sectionsCount()).to(equal(2))
            }
            
            describe("first section") {
                
                it("should have 2 items") {
                    expect(sut.sections[0].count).to(equal(2))
                }
                
                describe("first item") {
                    it("should be switch item") {
                        let item = sut.sections[0][0]
                        expect(item is SwitchItem).to(beTrue())
                    }
                }
                
                describe("second item") {
                    it("should be date item") {
                        let item = sut.sections[0][1]
                        expect(item is DateItem).to(beTrue())
                    }
                }
            }
            
            describe("second section") {
                
                it("should have 4 items") {
                    expect(sut.sections[1].count).to(equal(4))
                }
            }
        }
    }
}
