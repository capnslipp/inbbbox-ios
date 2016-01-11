//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class DefaultViewControllerPresenterSpec: QuickSpec {
    override func spec() {

        var sut: DefaultViewControllerPresenter!
        var viewControllerMock: ViewControllerMock!

        beforeEach {
            viewControllerMock = ViewControllerMock()
            sut = DefaultViewControllerPresenter(presentingViewController: viewControllerMock)
        }

        afterEach {
            sut = nil
        }

        describe("present view controller") {

            var fixtureViewController: UIViewController!
            var didInvokeCompletion: Bool!
            var capturedViewController: UIViewController!
            var capturedAnimated: Bool!

            beforeEach {
                fixtureViewController = UIViewController()

                viewControllerMock.presentViewControllerStub.on(any()) { viewController, animated, completion in
                    capturedViewController = viewController
                    capturedAnimated = animated
                    completion!()
                }

                sut.presentViewController(fixtureViewController, animated: true) {
                    didInvokeCompletion = true
                }
            }

            it("should present view controller") {
                expect(capturedViewController).to(equal(fixtureViewController))
            }

            it("should present view controller with proper animated flag") {
                expect(capturedAnimated).to(beTruthy())
            }

            it("should present view controller with completion") {
                expect(didInvokeCompletion).to(beTruthy())
            }
        }

        describe("dismiss view controller animated") {

            var didInvokeCompletion: Bool!
            var capturedAnimated: Bool!

            beforeEach {
                viewControllerMock.dismissViewControllerAnimatedStub.on(any()) {animated, completion in
                    capturedAnimated = animated
                    completion!()
                }

                sut.dismissViewControllerAnimated(true) {
                    didInvokeCompletion = true
                }
            }

            it("should dismiss view controller with proper animated flag") {
                expect(capturedAnimated).to(beTruthy())
            }

            it("should present view controller with completion") {
                expect(didInvokeCompletion).to(beTruthy())
            }
        }
    }
}
