//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//


import Quick
import Nimble

@testable import Inbbbox

class ShotsPresentationStepSpec: QuickSpec {

    override func spec() {

        var sut: ShotsPresentationStep!

        beforeEach {
            sut = ShotsPresentationStep()
        }

        afterEach {
            sut = nil
        }

        describe("presentation step") {

            describe("presentation step view controller") {

                var presentationStepViewController: PresentationStepViewController!

                beforeEach {
                    presentationStepViewController = sut.presentationStepViewController
                }

                it("should be shots collection view controller") {
                    expect(presentationStepViewController is ShotsCollectionViewController).to(beTruthy())
                }
            }
        }
    }
}
