//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotCollectionViewCellSpec: QuickSpec {
    override func spec() {

        var sut: ShotCollectionViewCell!

        beforeEach {
            sut = ShotCollectionViewCell(frame: CGRectZero)
        }

        afterEach {
            sut = nil
        }

        describe("shot image view") {

            var shotImageView: UIImageView!

            beforeEach {
                shotImageView = sut.shotImageView
            }

            it("should clip to bounds") {
                expect(shotImageView.clipsToBounds).to(beTruthy())
            }

            it("should have layer corner radius 5") {
                expect(shotImageView.layer.cornerRadius).to(equal(5))
            }

            it("should not translate autoresizing mask into constraints") {
                expect(shotImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(shotImageView))
            }
        }

        describe("height aware") {

            describe("preferred height") {

                var preferredHeight: CGFloat?

                beforeEach {
                    preferredHeight = ShotCollectionViewCell.prefferedHeight
                }

                it("should have preferred height 240") {
                    expect(preferredHeight).to(equal(240))
                }
            }
        }

        describe("reusable") {

            describe("reuse identifier") {

                var reuseIdentifier: String?

                beforeEach {
                    reuseIdentifier = ShotCollectionViewCell.reuseIdentifier
                }

                it("should have proper reuse identifier") {
                    expect(reuseIdentifier).to(equal("ShotCollectionViewCellIdentifier"))
                }
            }
        }
    }
}
