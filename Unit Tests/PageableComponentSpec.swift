//
//  PageableComponentSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 03/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Inbbbox

class PageableComponentSpec: QuickSpec {
    override func spec() {
        
        var sut: PageableComponent!

        afterEach {
            sut = nil
        }
        
        describe("when init with query only") {
           
            beforeEach {
                sut = PageableComponent(path: "fixture.path", query: nil)
            }
            
            it("path should be same") {
                expect(sut.path).to(equal("fixture.path"))
            }
            
            it("query items should have 1 item") {
                expect(sut.queryItems).to(beNil())
            }
        }
        
        describe("when init with query with 1 parameters pair") {
            
            beforeEach {
                sut = PageableComponent(path: "fixture.path", query: "fixture.name=fixture.value")
            }
            
            it("path should be same") {
                expect(sut.path).to(equal("fixture.path"))
            }
            
            it("query items should have 1 item") {
                expect(sut.queryItems).to(haveCount(1))
            }
            
            it("query item should have proper name and value") {
                expect(sut.queryItems?.first?.name).to(equal("fixture.name"))
                expect(sut.queryItems?.first?.value).to(equal("fixture.value"))
            }
        }
        
        describe("when init with query with 2 parameters pair") {
            
            beforeEach {
                sut = PageableComponent(path: "fixture.path", query: "fixture.name.1=fixture.value.1&fixture.name.2=fixture.value.2")
            }
            
            it("path should be same") {
                expect(sut.path).to(equal("fixture.path"))
            }
            
            it("query items should have 2 items") {
                expect(sut.queryItems).to(haveCount(2))
            }
            
            it("first query item should have proper name and value") {
                expect(sut.queryItems?.first?.name).to(equal("fixture.name.1"))
                expect(sut.queryItems?.first?.value).to(equal("fixture.value.1"))
            }
            
            it("second query item should have proper name and value") {
                expect(sut.queryItems?[1].name).to(equal("fixture.name.2"))
                expect(sut.queryItems?[1].value).to(equal("fixture.value.2"))
            }
        }
    }
}
