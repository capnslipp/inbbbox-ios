//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

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

        describe("like image view") {

            var likeImageView: UIImageView!

            beforeEach {
                likeImageView = sut.likeImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(likeImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(likeImageView))
            }
        }

        describe("bucket image view") {

            var bucketImageView: UIImageView!

            beforeEach {
                bucketImageView = sut.likeImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(bucketImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(bucketImageView))
            }
        }

        describe("comment image view") {

            var commentImageView: UIImageView!

            beforeEach {
                commentImageView = sut.likeImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(commentImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(commentImageView))
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

        describe("requires constraint based layout") {

            var requiresConstraintBasedLayout: Bool!

            beforeEach {
                requiresConstraintBasedLayout = ShotCollectionViewCell.requiresConstraintBasedLayout()
            }

            it("should require constraint based layout") {
                expect(requiresConstraintBasedLayout).to(beTruthy())
            }
        }

        describe("gesture recognizer should begin") {

            context("when gesture recognizer is pan gesture recognizer") {

                context("when user is scrolling with higher horizontal velocity") {

                    var gestureRecognizerShouldBegin: Bool!

                    beforeEach {
                        let panGestureRecognize = PanGestureRecognizerMock()
                        panGestureRecognize.velocityInViewStub.on(any()) { _ in
                            return CGPoint(x:100, y:0)
                        }
                        gestureRecognizerShouldBegin = sut.gestureRecognizerShouldBegin(panGestureRecognize)
                    }

                    it("should begin gesture recognizer") {
                        expect(gestureRecognizerShouldBegin).to(beTruthy())
                    }
                }

                context("when user is scrolling with higher vertical velocity") {

                    var gestureRecognizerShouldBegin: Bool!

                    beforeEach {
                        let panGestureRecognize = PanGestureRecognizerMock()
                        panGestureRecognize.velocityInViewStub.on(any()) { _ in
                            return CGPoint(x:0, y:100)
                        }
                        gestureRecognizerShouldBegin = sut.gestureRecognizerShouldBegin(panGestureRecognize)
                    }

                    it("should not begin gesture recognizer") {
                        expect(gestureRecognizerShouldBegin).to(beFalsy())
                    }
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

        describe("gesture recognizer delegate") {

            describe("gesture recognize should should recognize simultaneously") {

                var shouldRecognizeSimultaneously: Bool!

                beforeEach {
                    shouldRecognizeSimultaneously = sut.gestureRecognizer(UIGestureRecognizer(), shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer())
                }

                it("should alwawys recognize simultaneously all gesture recognizers") {
                    expect(shouldRecognizeSimultaneously).to(beTruthy())
                }
            }
        }
    }
}
