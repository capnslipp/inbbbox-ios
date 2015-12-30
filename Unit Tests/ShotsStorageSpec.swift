//
//  ShotsStorageSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 30/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotsStorageSpec: QuickSpec {
    override func spec() {
        
        describe("when loading shots from assets catalog") {
            
            var sut: ShotsStorage!
            
            beforeEach {
                sut = ShotsStorage()
            }
            
            it("should have 16 assets loaded") {
                expect(sut.shotsFromAssetCatalog).to(haveCount(16))
            }
        }
    }
}
