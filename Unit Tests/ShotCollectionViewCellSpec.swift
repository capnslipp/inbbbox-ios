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

        describe("swiping cell") {

            var panGestureRecognizer: UIPanGestureRecognizer!

            beforeEach {
                panGestureRecognizer = sut.contentView.gestureRecognizers!.filter{$0.isKindOfClass(UIPanGestureRecognizer)}.first as! UIPanGestureRecognizer!
            }

            context("when swipe began") {

                var delegateMock: ShotCollectionViewCellDelegateMock!
                var didInformDelegateCellDidStartSwiping: Bool!

                beforeEach {
                    delegateMock = ShotCollectionViewCellDelegateMock()
                    didInformDelegateCellDidStartSwiping = false
                    delegateMock.shotCollectionViewCellDidStartSwipingStub.on(any()) { _ in
                        didInformDelegateCellDidStartSwiping = true
                    }
                    sut.delegate = delegateMock
                    let panGestureRecognizerMock = PanGestureRecognizerMock()
                    panGestureRecognizerMock.stateStub.on(any()) {
                        return .Began
                    }
                    panGestureRecognizer!.specRecognizeWithGestureRecognizer(panGestureRecognizerMock)
                }

                it("should inform delegate that cell did start swiping") {
                    expect(didInformDelegateCellDidStartSwiping).to(beTruthy())
                }
            }

            context("when swipe ended") {

                var panGestureRecognizerMock: PanGestureRecognizerMock!

                var capturedDuration: NSTimeInterval!
                var capturedDelay: NSTimeInterval!
                var capturedDamping: CGFloat!
                var capturedVelocity: CGFloat!
                var capturedOptions: UIViewAnimationOptions!
                var capturedAnimations: (() -> Void)!
                var capturedCompletion: ((Bool) -> Void)!

                beforeEach {
                    let viewClassMock = ViewMock.self
                    viewClassMock.springAnimationStub.on(any()) { duration, delay, damping, velocity, options, animations, completion in
                        capturedDuration = duration
                        capturedDelay = delay
                        capturedDamping = damping
                        capturedVelocity = velocity
                        capturedOptions = options
                        capturedAnimations = animations
                        capturedCompletion = completion
                    }
                    sut.viewClass = viewClassMock
                    panGestureRecognizerMock = PanGestureRecognizerMock()
                    panGestureRecognizerMock.stateStub.on(any()) {
                        return .Ended
                    }

                    panGestureRecognizer!.specRecognizeWithGestureRecognizer(panGestureRecognizerMock)
                }

                it("should animate returning to initial cell state with duration 0.3") {
                    expect(capturedDuration).to(equal(0.3))
                }

                it("should animate returning to initial cell state without delay") {
                    expect(capturedDelay).to(equal(0))
                }

                it("should animate returning to initial cell state with damping 0.6") {
                    expect(capturedDamping).to(equal(0.6))
                }

                it("should animate returning to initial cell state with velocity 0.9") {
                    expect(capturedVelocity).to(equal(0.9))
                }

                it("should animate returning to initial cell state with ease in out option") {
                    expect(capturedOptions == UIViewAnimationOptions.CurveEaseInOut).to(beTruthy())
                }

                describe("animations block") {

                    beforeEach {
                        sut.shotImageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 100, 0)
                        capturedAnimations()
                    }

                    it("should restore shot image view identity tranform") {
                        expect(CGAffineTransformEqualToTransform(sut.shotImageView.transform, CGAffineTransformIdentity)).to(beTruthy())
                    }
                }

                describe("completion block") {

                    var delegateMock: ShotCollectionViewCellDelegateMock!
                    var didInformDelegateCellDidEndSwiping: Bool!
                    var capturedAction: ShotCollectionViewCellAction!

                    beforeEach {
                        sut.swipeCompletion = { action in
                            capturedAction = action
                        }
                        delegateMock = ShotCollectionViewCellDelegateMock()
                        didInformDelegateCellDidEndSwiping = false
                        delegateMock.shotCollectionViewCellDidEndSwipingStub.on(any()) { _ in
                            didInformDelegateCellDidEndSwiping = true
                        }
                        sut.delegate = delegateMock
                    }

                    context("when user swiped slightly right") {

                        beforeEach {
                            panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                                return CGPoint(x: 50, y:0)
                            }
                            capturedCompletion(true)
                        }

                        it("should invoke swipe completion with Like action") {
                            expect(capturedAction).to(equal(ShotCollectionViewCellAction.Like))
                        }

                        it("should inform delegate that cell did end swiping") {
                            expect(didInformDelegateCellDidEndSwiping).to(beTruthy())
                        }
                    }

                    context("when user swiped considerably right") {

                        beforeEach {
                            panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                                return CGPoint(x: 150, y:0)
                            }
                            capturedCompletion(true)
                        }

                        it("should invoke swipe completion with Bucket action") {
                            expect(capturedAction).to(equal(ShotCollectionViewCellAction.Bucket))
                        }

                        it("should inform delegate that cell did end swiping") {
                            expect(didInformDelegateCellDidEndSwiping).to(beTruthy())
                        }
                    }

                    context("when user swiped slightly left") {

                        beforeEach {
                            panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                                return CGPoint(x: -50, y:0)
                            }
                            capturedCompletion(true)
                        }

                        it("should invoke swipe completion with Comment action") {
                            expect(capturedAction).to(equal(ShotCollectionViewCellAction.Comment))
                        }

                        it("should inform delegate that cell did end swiping") {
                            expect(didInformDelegateCellDidEndSwiping).to(beTruthy())
                        }
                    }
                }
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
