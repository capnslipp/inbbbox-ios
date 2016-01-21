//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class ShotsCollectionViewControllerSpec: QuickSpec {

    override func spec() {

        var sut: ShotsCollectionViewController!

        beforeEach {
            sut = ShotsCollectionViewController()
        }

        afterEach() {
            sut = nil
        }

        it("should have initial shots collection view layout") {
            expect(sut.collectionViewLayout).to(beAKindOf(InitialShotsCollectionViewLayout))
        }

        it("should be animation manager's delegate") {
            expect(sut.animationManager.delegate === sut).to(beTruthy())
        }

        describe("when view did load") {

            beforeEach {
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [sut]
                let _ = sut.view
            }

            it("should have user interaction initially disabled on tab bar") {
                expect(sut.tabBarController?.tabBar.userInteractionEnabled).to(beFalsy())
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

            var didStartAnimationWithCompletion: Bool!
            var capturedCompletion: (() -> ())!

            beforeEach {
                let _ = sut.view
                let animationManagerMock = ShotsAnimationManagerMock()
                didStartAnimationWithCompletion = false
                animationManagerMock.startAnimationWithCompletionStub.on(any()) { completion in
                    didStartAnimationWithCompletion = true
                    capturedCompletion = completion
                }
                sut.animationManager = animationManagerMock
                sut.viewDidAppear(true)
            }

            it("should start animation with completion") {
                expect(didStartAnimationWithCompletion).to(beTruthy())
            }

            describe("animation completion") {

                var didReloadCollectionViewData: Bool!

                beforeEach {
                    let tabBarController = UITabBarController()
                    tabBarController.viewControllers = [sut]

                    let collectionViewMock = CollectionViewMock()
                    didReloadCollectionViewData = false
                    collectionViewMock.reloadDataStub.on(any()) {
                        didReloadCollectionViewData = true
                    }
                    sut.collectionView = collectionViewMock
                    capturedCompletion()
                }

                it("should change collection view layout to flow layout") {
                    expect(sut.collectionView!.collectionViewLayout).to(beAKindOf(ShotsCollectionViewFlowLayout))
                }

                it("should reload collection view data") {
                    expect(didReloadCollectionViewData).to(beTruthy())
                }

                it("should have user interaction enabled on tab bar") {
                    expect(sut.tabBarController?.tabBar.userInteractionEnabled).to(beTruthy())
                }
            }
        }

        describe("collection view data source") {

            describe("cell for item at index path") {

                var item: UICollectionViewCell!

                beforeEach {
                    sut.animationManager.visibleItems = ["fixtureShot1"]
                    item = sut.collectionView(sut.collectionView!, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should dequeue shot collection view cell") {
                    expect(item).to(beAKindOf(ShotCollectionViewCell))
                }
            }
        }

        describe("collection view data source") {

            describe("number of items in section") {

                var numberOfItems: Int!

                context("when animations did not finish") {

                    beforeEach {
                        sut.animationManager.visibleItems = ["shot1", "shot2"]
                        numberOfItems = sut.collectionView(CollectionViewMock(), numberOfItemsInSection: 0)
                    }

                    it("should return number of visible items provided by animation manager") {
                        expect(numberOfItems).to(equal(2))
                    }
                }

                context("when animations did finish") {

                    beforeEach {
                        let animationManagerMock = ShotsAnimationManagerMock()
                        animationManagerMock.startAnimationWithCompletionStub.on(any()) { completion in
                            completion?()
                        }
                        sut.animationManager = animationManagerMock
                        sut.viewDidAppear(true)
                        numberOfItems = sut.collectionView(CollectionViewMock(), numberOfItemsInSection: 0)
                    }

                    it("should return number of shots") {
                        expect(numberOfItems).to(equal(10))
                    }
                }
            }

            describe("cell for item at index path") {

                var cell: UICollectionViewCell!
                var capturedIdentifier: String!

                beforeEach {
                    let collectionViewMock = CollectionViewMock()
                    collectionViewMock.dequeueReusableCellWithReuseIdentifierStub.on(any()) { identifier, _ in
                        capturedIdentifier = identifier
                        return ShotCollectionViewCell()
                    }
                    cell = sut.collectionView(collectionViewMock, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should dequeue cell with proper identifier") {
                    expect(capturedIdentifier).to(equal("ShotCollectionViewCellIdentifier"))
                }
            }
        }

        describe("shots animation manager delegate") {

            describe("colleciton view for animation manager") {

                var collectionView: UICollectionView!

                beforeEach {
                    collectionView = sut.collectionViewForAnimationManager(ShotsAnimationManager())
                }

                it("should return proper collection view") {
                    expect(collectionView).to(equal(sut.collectionView))
                }
            }

            describe("items for animation manager") {

                var items: [AnyObject]!

                beforeEach {
                    items = sut.itemsForAnimationManager(ShotsAnimationManager())
                }

                it("should have first 3 items") {
                    expect(items.count).to(equal(3))
                }
            }
        }
    }
}
