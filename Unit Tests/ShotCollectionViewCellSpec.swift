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

            var likeImageView: DoubleImageView!

            beforeEach {
                likeImageView = sut.likeImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(likeImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(likeImageView))
            }

            it("should have proper first image") {
                expect(UIImagePNGRepresentation(likeImageView.firstImageView.image!)).to(equal(UIImagePNGRepresentation(UIImage(named: "ic-like-swipe")!)))
            }

            it("should have proper second image") {
                expect(UIImagePNGRepresentation(likeImageView.secondImageView.image!)).to(equal(UIImagePNGRepresentation(UIImage(named: "ic-like-swipe-filled")!)))
            }
        }

        describe("bucket image view") {

            var bucketImageView: UIImageView!

            beforeEach {
                bucketImageView = sut.bucketImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(bucketImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(bucketImageView))
            }

            it("should have proper image") {
                expect(UIImagePNGRepresentation(bucketImageView.image!)).to(equal(UIImagePNGRepresentation(UIImage(named: "ic-bucket-swipe")!)))
            }
        }

        describe("comment image view") {

            var commentImageView: UIImageView!

            beforeEach {
                commentImageView = sut.commentImageView
            }

            it("should not translate autoresizing mask into constraints") {
                expect(commentImageView.translatesAutoresizingMaskIntoConstraints).to(beFalsy())
            }

            it("should be added to cell content view subviews") {
                expect(sut.contentView.subviews).to(contain(commentImageView))
            }

            it("should have proper image") {
                expect(UIImagePNGRepresentation(commentImageView.image!)).to(equal(UIImagePNGRepresentation(UIImage(named: "ic-comment")!)))
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
                var viewClassMock: ViewMock.Type!

                var capturedRestoreInitialStateDuration: NSTimeInterval!
                var capturedRestoreInitialStateDelay: NSTimeInterval!
                var capturedRestoreInitialStateDamping: CGFloat!
                var capturedRestoreInitialStateVelocity: CGFloat!
                var capturedRestoreInitialStateOptions: UIViewAnimationOptions!
                var capturedRestoreInitialStateAnimations: (() -> Void)!
                var capturedRestoreInitialStateCompletion: ((Bool) -> Void)!

                beforeEach {
                    viewClassMock = ViewMock.self
                    viewClassMock.springAnimationStub.on(any()) { duration, delay, damping, velocity, options, animations, completion in
                        capturedRestoreInitialStateDuration = duration
                        capturedRestoreInitialStateDelay = delay
                        capturedRestoreInitialStateDamping = damping
                        capturedRestoreInitialStateVelocity = velocity
                        capturedRestoreInitialStateOptions = options
                        capturedRestoreInitialStateAnimations = animations
                        capturedRestoreInitialStateCompletion = completion
                    }
                    sut.viewClass = viewClassMock
                    panGestureRecognizerMock = PanGestureRecognizerMock()
                    panGestureRecognizerMock.stateStub.on(any()) {
                        return .Ended
                    }
                }

                sharedExamples("returning to initial cell state animation") { (sharedExampleContext: SharedExampleContext) in

                    it("should animate returning to initial cell state with duration 0.3") {
                        expect(capturedRestoreInitialStateDuration).to(equal(0.3))
                    }

                    it("should animate returning to initial cell state without delay") {
                        expect(capturedRestoreInitialStateDelay).to(equal(sharedExampleContext()["expectedDelay"] as? NSTimeInterval))
                    }

                    it("should animate returning to initial cell state with damping 0.6") {
                        expect(capturedRestoreInitialStateDamping).to(equal(0.6))
                    }

                    it("should animate returning to initial cell state with velocity 0.9") {
                        expect(capturedRestoreInitialStateVelocity).to(equal(0.9))
                    }

                    it("should animate returning to initial cell state with ease in out option") {
                        expect(capturedRestoreInitialStateOptions == UIViewAnimationOptions.CurveEaseInOut).to(beTruthy())
                    }

                    describe("restore initial state animations block") {

                        beforeEach {
                            sut.shotImageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 100, 0)
                            capturedRestoreInitialStateAnimations()
                        }

                        it("should restore shot image view identity tranform") {
                            expect(CGAffineTransformEqualToTransform(sut.shotImageView.transform, CGAffineTransformIdentity)).to(beTruthy())
                        }
                    }

                    describe("restore initial state completion block") {

                        var delegateMock: ShotCollectionViewCellDelegateMock!
                        var didInformDelegateCellDidEndSwiping: Bool!
                        var capturedAction: ShotCollectionViewCell.Action!

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
                            sut.bucketImageView.hidden = true
                            sut.commentImageView.hidden = true
                            sut.likeImageView.firstImageView.alpha = 0
                            sut.likeImageView.secondImageView.alpha = 1
                            capturedRestoreInitialStateCompletion(true)
                        }

                        it("should invoke swipe completion with Comment action") {
                            let actionWrapper = sharedExampleContext()["expectedAction"] as! ShotCollectionViewCellActionWrapper
                            expect(capturedAction).to(equal(actionWrapper.action))
                        }

                        it("should inform delegate that cell did end swiping") {
                            expect(didInformDelegateCellDidEndSwiping).to(beTruthy())
                        }

                        it("show bucket image view") {
                            expect(sut.bucketImageView.hidden).to(beFalsy())
                        }

                        it("show comment image view") {
                            expect(sut.commentImageView.hidden).to(beFalsy())
                        }

                        describe("like image view") {

                            var likeImageView: DoubleImageView!

                            beforeEach {
                                likeImageView = sut.likeImageView
                            }

                            it("should display first image view") {
                                expect(likeImageView.firstImageView.alpha).to(equal(1))
                            }

                            it("should hide second image view") {
                                expect(likeImageView.secondImageView.alpha).to(equal(0))
                            }
                        }
                    }
                }

                context("when user swiped slightly right") {

                    var capturedLikeActionDuration: NSTimeInterval!
                    var capturedLikeActionDelay: NSTimeInterval!
                    var capturedLikeActionOptions: UIViewAnimationOptions!
                    var capturedLikeActionAnimations: (() -> Void)!
                    var capturedLikeActionCompletion: ((Bool) -> Void)!

                    beforeEach {
                        viewClassMock.animationStub.on(any()) { duration, delay, options, animations, completion in
                            capturedLikeActionDuration = duration
                            capturedLikeActionDelay = delay
                            capturedLikeActionOptions = options
                            capturedLikeActionAnimations = animations
                            capturedLikeActionCompletion = completion
                        }
                        panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                            return CGPoint(x: 50, y:0)
                        }
                        panGestureRecognizer!.specRecognizeWithGestureRecognizer(panGestureRecognizerMock)
                    }

                    it("should animate like action with duration 0.3") {
                        expect(capturedLikeActionDuration).to(equal(0.3))
                    }

                    it("should animate like action without delay") {
                        expect(capturedLikeActionDelay).to(equal(0))
                    }

                    it("should animate like action without options") {
                        expect(capturedLikeActionOptions).to(equal([]))
                    }

                    describe("like action animations block") {

                        beforeEach {
                            sut.contentView.bounds = CGRect(x: 0, y: 0, width: 100, height: 0)
                            sut.likeImageView.alpha = 0
                            capturedLikeActionAnimations()
                        }

                        it("should set shot image view tranform") {
                            expect(CGAffineTransformEqualToTransform(sut.shotImageView.transform, CGAffineTransformTranslate(CGAffineTransformIdentity, 100, 0))).to(beTruthy())
                        }

                        describe("like image view") {

                            var likeImageView: DoubleImageView!

                            beforeEach {
                                likeImageView = sut.likeImageView
                            }

                            it("should have alpha 1") {
                                expect(likeImageView.alpha).to(equal(1.0))
                            }

                            it("should display second image view") {
                                expect(likeImageView.secondImageView.alpha).to(equal(1))
                            }

                            it("should hide first image view") {
                                expect(likeImageView.firstImageView.alpha).to(equal(0))
                            }
                        }
                    }

                    describe("like action completion block") {

                        beforeEach {
                            capturedLikeActionCompletion(true)
                        }

                        itBehavesLike("returning to initial cell state animation") {
                            ["expectedDelay": 0.2,
                             "expectedAction": ShotCollectionViewCellActionWrapper(action: ShotCollectionViewCell.Action.Like)]
                        }
                    }
                }

                context("when user swiped considerably right") {

                    beforeEach {
                        panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                            return CGPoint(x: 150, y:0)
                        }
                        panGestureRecognizer!.specRecognizeWithGestureRecognizer(panGestureRecognizerMock)
                    }

                    itBehavesLike("returning to initial cell state animation") {
                        ["expectedDelay": 0.0,
                         "expectedAction": ShotCollectionViewCellActionWrapper(action: ShotCollectionViewCell.Action.Bucket)]
                    }
                }

                context("when user swiped slightly left") {

                    beforeEach {
                        panGestureRecognizerMock.translationInViewStub.on(any()) { _ in
                            return CGPoint(x: -50, y:0)
                        }
                        panGestureRecognizer!.specRecognizeWithGestureRecognizer(panGestureRecognizerMock)
                    }

                    itBehavesLike("returning to initial cell state animation") {
                        ["expectedDelay": 0.0,
                         "expectedAction": ShotCollectionViewCellActionWrapper(action: ShotCollectionViewCell.Action.Comment)]
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
