//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotsCollectionBackgroundViewSpec: QuickSpec {

    override func spec() {

        var sut: ShotsCollectionBackgroundView!

        beforeEach {
            sut = ShotsCollectionBackgroundView()
        }

        afterEach() {
            sut = nil
        }

        describe("logo image view") {

            var logoImageView: UIImageView!

            beforeEach {
                logoImageView = sut.logoImageView
            }

            it("should have proper image") {
                expect(UIImagePNGRepresentation(logoImageView.image!)).to(equal(UIImagePNGRepresentation(UIImage(named: "logo-type-home")!)))
            }

            it("should be configured for auto layout") {
                expect(logoImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to subviews") {
                expect(sut.subviews).to(contain(logoImageView))
            }
        }
    }
}
