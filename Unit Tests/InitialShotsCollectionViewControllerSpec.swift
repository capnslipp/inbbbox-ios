
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class InitialShotsCollectionViewControllerSpec: QuickSpec {

    override func spec() {

        var sut: InitialShotsCollectionViewController!

        beforeEach {
            sut = InitialShotsCollectionViewController()
        }

        afterEach() {
            sut = nil
        }

        it("should have initial shots collection view layout") {
            expect(sut.collectionViewLayout).to(beAKindOf(InitialShotsCollectionViewLayout))
        }

        it("should have animation manager") {
            expect(sut.animationManager).toNot(beNil())
        }

        describe("when view did load") {

            beforeEach {
                sut.view
            }

            describe("collection view") {

                var collectionView: UICollectionView!

                beforeEach {
                    collectionView = sut.collectionView
                }

                it("should have paging enabled") {
                    expect(collectionView.pagingEnabled).to(beTruthy())
                }
            }
        }

        describe("view did appear") {

            var animationManagerMock: InitialShotsAnimationManagerMock!
            var capturedCompletion: (Void -> Void)!

            beforeEach {
                animationManagerMock = InitialShotsAnimationManagerMock()
                animationManagerMock.startAnimationWithCompletionStub.on(any()) { completion in
                    capturedCompletion = completion
                }
                sut.animationManager = animationManagerMock
                sut.viewDidAppear(true)
            }

            describe("animation completion") {

                var capturedPresentationStepViewController: PresentationStepViewController!

                beforeEach {
                    let presentationStepViewControllerDelegateMock = PresentationStepViewControllerDelegateMock()
                    presentationStepViewControllerDelegateMock.presentationStepViewControllerDidFinishPresentingStub.on(any()) { presentationStepViewController in
                        capturedPresentationStepViewController = presentationStepViewController
                    }
                    sut.presentationStepViewControllerDelegate = presentationStepViewControllerDelegateMock
                    capturedCompletion!()
                }

                it("should inform presentation step view controller delegate that that presentation step view controller did finish") {
                    expect(capturedPresentationStepViewController === sut).to(beTruthy())
                }
            }
        }

        describe("collection view data source") {

            describe("number of items in section") {

                var numberOfItems: Int!

                beforeEach {
                    sut.animationManager.visibleItems = ["fixture item 1", "fixture item 2"]
                    numberOfItems = sut.collectionView(sut.collectionView!, numberOfItemsInSection: 0)
                }

                it("have number of items based on animation manager's visible items") {
                    expect(numberOfItems).to(equal(2))
                }
            }

            describe("cell for item at index path") {

                var item: UICollectionViewCell!

                beforeEach{
                    sut.animationManager.visibleItems = ["fixture item 1"]
                    item = sut.collectionView(sut.collectionView!, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should dequeue shot collection view cell"){
                    expect(item).to(beAKindOf(ShotCollectionViewCell))
                }
            }
        }

        describe("initial shots animation manager delegate") {

            describe("collection view for animation manager") {

                var collectionView: UICollectionView!

                beforeEach {
                    collectionView = sut.collectionViewForAnimationManager(sut.animationManager)
                }

                it("should return proper collection view") {
                    expect(collectionView).to(equal(sut.collectionView))
                }
            }

            describe("items for animation manager") {

                var itemsForAnimationManager: [String]!

                beforeEach {
                    itemsForAnimationManager = sut.itemsForAnimationManager(sut.animationManager) as! [String]
                }

                it("should return shots") {
                    expect(itemsForAnimationManager).to(equal(sut.shots))
                }
            }
        }

        describe("presentation step view controller") {

            describe("view controller") {

                var viewController: UIViewController!

                beforeEach {
                    viewController = sut.viewController
                }

                it("should return initial shots collection view controller") {
                    expect(viewController).to(equal(sut))
                }
            }
        }
    }
}
