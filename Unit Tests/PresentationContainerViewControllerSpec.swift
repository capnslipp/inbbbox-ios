//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class PresentationContainerViewControllerSpec: QuickSpec {

    override func spec() {

        var sut: PresentationContainerViewController!

        var firstPresentationStepMock: PresentationStepMock!
        var firstFixtureViewController: UIViewController!

        var secondPresentationStepMock: PresentationStepMock!
        var secondFixtureViewController: UIViewController!

        beforeEach {
            sut = PresentationContainerViewController()

            firstPresentationStepMock = PresentationStepMock()
            let firstPresentationStepViewControllerMock = PresentationStepViewControllerMock()
            firstFixtureViewController = UIViewController()
            firstPresentationStepMock.presentationStepViewControllerStub.on(any(), returnValue: firstPresentationStepViewControllerMock)
            firstPresentationStepViewControllerMock.viewControllerStub.on(any(), returnValue: firstFixtureViewController)

            secondPresentationStepMock = PresentationStepMock()
            let secondPresentationStepViewControllerMock = PresentationStepViewControllerMock()
            secondFixtureViewController = UIViewController()
            secondPresentationStepMock.presentationStepViewControllerStub.on(any(), returnValue: secondPresentationStepViewControllerMock)
            secondPresentationStepViewControllerMock.viewControllerStub.on(any(), returnValue: secondFixtureViewController)

            sut.presentationSteps = [firstPresentationStepMock, secondPresentationStepMock]
        }

        afterEach {
            sut = nil
        }

        it("should have default view controller presenter") {
            expect(sut.viewControllerPresenter is DefaultViewControllerPresenter).to(beTruthy())
        }

        describe("view did load") {

            beforeEach {
                sut.view
            }

            it("should set first presentation step delegate to presentation container view controller") {
                expect(firstPresentationStepMock.presentationStepDelegate === sut).to(beTruthy())
            }

            it("should add first presentation step view controller to child view controllers") {
                expect(sut.childViewControllers).to(contain(firstFixtureViewController))
            }

            it("should add first presentation step view controller's view to view subviews") {
                expect(sut.view.subviews).to(contain(firstFixtureViewController.view))
            }

            it("should not translate autoresizing mask into constraints for first presentation step view controller's view") {
                expect(firstFixtureViewController.view.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }
        }

        describe("resentation step delegate") {

            describe("presentation step did finish") {

                var viewControllerPresenterMock: ViewControllerPresenterMock!

                var capturedPresentedViewController: UIViewController!
                var capturedAnimated: Bool!
                var capturedCompletion: (() -> Void)!

                beforeEach {
                    viewControllerPresenterMock = ViewControllerPresenterMock()
                    viewControllerPresenterMock.presentViewControllerStub.on(any()) { presentedViewController, animated, completion in
                        capturedPresentedViewController = presentedViewController
                        capturedAnimated = animated
                        capturedCompletion = completion
                    }
                    sut.viewControllerPresenter = viewControllerPresenterMock
                    let _ = sut.view
                    sut.presentationStepDidFinish(firstPresentationStepMock)
                }

                it("should remove first presentation step view controller child view controlelr") {
                    expect(sut.childViewControllers).toNot(contain(firstFixtureViewController))
                }

                it("should remove first presentation step view controller's view from view subviews") {
                    expect(sut.view.subviews).toNot(contain(firstFixtureViewController.view))
                }

                context("when second step is the last step") {

                    it("should present proper view controller") {
                        expect(capturedPresentedViewController).to(equal(secondFixtureViewController))
                    }

                    it("should present view controller without animation") {
                        expect(capturedAnimated).to(beFalsy())
                    }

                    it("should present view controller without completion") {
                        expect(capturedCompletion).to(beNil())
                    }
                }
            }
        }
    }
}
