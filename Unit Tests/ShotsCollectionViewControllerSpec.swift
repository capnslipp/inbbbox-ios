//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby
import PromiseKit

@testable import Inbbbox

class ShotsCollectionViewControllerSpec: QuickSpec {

    override func spec() {

        var sut: ShotsCollectionViewController!

        beforeEach {
            sut = ShotsCollectionViewController()
        }

        afterEach {
            sut = nil
        }

        it("should have initial shots collection view layout") {
            expect(sut.collectionViewLayout).to(beAKindOf(InitialShotsCollectionViewLayout))
        }

        it("should be animation manager's delegate") {
            expect(sut.animationManager.delegate === sut).to(beTruthy())
        }

        describe("when view did load") {

            var tabBarController: UITabBarController!

            beforeEach {
                tabBarController = UITabBarController()
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

                it("should have proper background view") {
                    expect(collectionView.backgroundView).to(beAKindOf(ShotsCollectionBackgroundView))
                }
            }
        }

        // NGRTodo: Update this spec
        pending("implementation changed") {
            describe("view did appear") {

                var didStartAnimationWithCompletion: Bool!
                var capturedCompletion: (() -> ())!

                beforeEach {
                    let _ = sut.view
                    let animationManagerMock = ShotsAnimatorMock()
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
                    var tabBarController: UITabBarController!

                    beforeEach {
                        tabBarController = UITabBarController()
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
        }

        describe("collection view data source") {

            describe("number of items in section") {

                var numberOfItems: Int!

                context("when animations did not finish") {

                    beforeEach {
                        let shot = Shot.fixtureShot()
                        sut.animationManager.visibleItems = [shot, shot]
                        numberOfItems = sut.collectionView(CollectionViewMock(), numberOfItemsInSection: 0)
                    }

                    it("should return number of visible items provided by animation manager") {
                        expect(numberOfItems).to(equal(2))
                    }
                }

                // NGRTodo: Update this spec
                pending("implementation changed") {
                    context("when animations did finish") {

                        beforeEach {
                            let animationManagerMock = ShotsAnimatorMock()
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
            }

            describe("cell for item at index path") {

                var cell: ShotCollectionViewCell!
                var capturedIdentifier: String!

                beforeEach {
                    sut.shots = [Shot.fixtureShot()]
                    let collectionViewMock = CollectionViewMock()
                    collectionViewMock.dequeueReusableCellWithReuseIdentifierStub.on(any()) { identifier, _ in
                        capturedIdentifier = identifier
                        return ShotCollectionViewCell()
                    }
                    cell = sut.collectionView(collectionViewMock, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as! ShotCollectionViewCell
                }

                it("should not be nil") {
                    expect(cell).toNot(beNil())
                }

                it("should dequeue cell with proper identifier") {
                    expect(capturedIdentifier).to(equal("ShotCollectionViewCellIdentifier"))
                }

                describe("swipe completion") {

                    context("when action is like") {
                        
                        context("when user is not signed in") {
                            
                            var capturedShotID: String!
                            
                            beforeEach {
                                let localStorageMock = ShotsLocalStorageMock()
                                localStorageMock.likeStub.on(any()) { shotID in
                                    capturedShotID = shotID
                                }
                                sut.localStorage = localStorageMock
                                
                                cell.swipeCompletion?(.Like)
                            }
                            
                            it("should like shot locally with proper ID") {
                                expect(capturedShotID).to(equal("2479405"))
                            }
                        }

                        context("when user is signed in") {
                            
                            var capturedShotID: String!

                            beforeEach {
                                let userStorageMockClass = UserStorageMock.self
                                userStorageMockClass.currentUserStub.on(any()) { _ in
                                    return User.fixtureUser()
                                }
                                sut.userStorageClass = userStorageMockClass
                                
                                let shotOperationRequesterMockClass = ShotOperationRequesterMock.self
                                shotOperationRequesterMockClass.likeShotStub.on(any()) { shotID in
                                    capturedShotID = shotID
                                    return Promise<Void> { _, _ in }
                                }
                                sut.shotOperationRequesterClass = shotOperationRequesterMockClass
                                
                                cell.swipeCompletion?(.Like)
                            }

                            it("should like shot with proper ID") {
                                expect(capturedShotID).to(equal("2479405"))
                            }
                        }
                    }
                }
            }
        }

        describe("shots animation manager delegate") {

            describe("colleciton view for animation manager") {

                var collectionView: UICollectionView!

                beforeEach {
                    collectionView = sut.collectionViewForShotsAnimator(ShotsAnimator())
                }

                it("should return proper collection view") {
                    expect(collectionView).to(equal(sut.collectionView))
                }
            }

            describe("items for animation manager") {

                var items: [Shot]!

                beforeEach {
                    let shot = Shot.fixtureShot()
                    sut.shots = [shot, shot, shot, shot, shot]
                    items = sut.itemsForShotsAnimator(ShotsAnimator())
                }

                it("should have first 3 items") {
                    expect(items.count).to(equal(3))
                }
            }
        }
    }
}
