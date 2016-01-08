//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//


import Quick
import Nimble
import Dobby

@testable import Inbbbox

class InitialShotsPresentationStepSpec: QuickSpec {

    override func spec() {

        var sut: InitialShotsPresentationStep!

        beforeEach {
            sut = InitialShotsPresentationStep()
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

                it("should be initial shots collection view controller") {
                    expect(presentationStepViewController is InitialShotsCollectionViewController).to(beTruthy())
                }

                it("should have initial shots presentation step as presentation view controller delegate") {
                    expect(presentationStepViewController.presentationStepViewControllerDelegate === sut).to(beTruthy())
                }
            }
        }

        describe("presentation step view controller delegate") {

            describe("presentation step view controller did finish presenting") {

                var capturedPresentationStep: PresentationStep!

                beforeEach {
                    let presentationStepDelegateMock = PresentationStepDelegateMock()
                    presentationStepDelegateMock.presentationStepDidFinishStub.on(any()) { presentationStep in
                        capturedPresentationStep = presentationStep
                    }
                    sut.presentationStepDelegate = presentationStepDelegateMock
                    sut.presentationStepViewControllerDidFinishPresenting(InitialShotsCollectionViewController())
                }

                it("should inform presentation step delegate that presentation step did finish") {
                    expect(capturedPresentationStep === sut).to(beTruthy())
                }
            }
        }
    }
}
