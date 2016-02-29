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
        
        pending("pending because of random crashes") {
            
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
                    
                    var items: [ShotType]!
                    
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
}
