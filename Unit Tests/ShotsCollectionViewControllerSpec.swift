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
                expect(sut.tabBarController!.tabBar.userInteractionEnabled).to(beFalsy())
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
                    expect(sut.tabBarController!.tabBar.userInteractionEnabled).to(beTruthy())
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
    }
}
