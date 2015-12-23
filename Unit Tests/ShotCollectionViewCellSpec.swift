//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotCollectionViewCellSpec: QuickSpec {
    override func spec() {

        describe("height aware") {

            describe("preferred height") {

                var preferredHeight: CGFloat?

                beforeEach() {
                    preferredHeight = ShotCollectionViewCell.prefferedHeight
                }

                it("should have preferred height 235") {
                    expect(preferredHeight).to(equal(235))
                }
            }
        }

        describe("reusable") {

            describe("reuse identifier") {

                var reuseIdentifier: String?

                beforeEach() {
                    reuseIdentifier = ShotCollectionViewCell.reuseIdentifier
                }

                it("should have proper reuse identifier") {
                    expect(reuseIdentifier).to(equal("ShotCollectionViewCellIdentifier"))
                }
            }
        }
    }
}
