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
        
        describe("conent view") {
            
            var contentView: UIView!
            
            beforeEach {
                contentView = sut.contentView
            }
            
            it("should clip to bounds") {
                expect(contentView.clipsToBounds).to(beTruthy())
            }
            
            it("should have layer corner radius 5") {
                expect(contentView.layer.cornerRadius).to(equal(5))
            }
        }

        describe("shot image view") {

            var shotImageView: UIImageView!

            beforeEach {
                shotImageView = sut.shotImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(shotImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(shotImageView))
            }
        }

        describe("height declaring") {

            describe("preferred height") {

                var preferredHeight: CGFloat?

                beforeEach {
                    preferredHeight = ShotCollectionViewCell.preferredHeight
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
