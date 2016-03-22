//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class InitialShotsCollectionViewLayoutSpec: QuickSpec {

    override func spec() {

        var sut: InitialAnimationsShotsCollectionViewLayout!
        var collectionViewMock: CollectionViewMock!
        let fixtureCollectionViewBounds = FixtureCollectionViewBounds()
        let fixtureFirstItemAttributes = FixtureFirstItemAttributes()
        let fixtureSecondItemAttributes = FixtureSecondItemAttributes()

        beforeEach {
            sut = InitialAnimationsShotsCollectionViewLayout()
            collectionViewMock = CollectionViewMock(frame: CGRectZero, collectionViewLayout: sut!)
        }

        afterEach() {
            sut = nil
        }

        describe("collection view layout") {

            describe("collection view content size") {

                var contentSize: CGSize!

                beforeEach {
                    collectionViewMock.bounds = CGRect(x: fixtureCollectionViewBounds.x, y: fixtureCollectionViewBounds.y, width: fixtureCollectionViewBounds.width, height: fixtureCollectionViewBounds.height)
                    contentSize = sut.collectionViewContentSize()
                }

                it("should have proper content size") {
                    expect(contentSize).to(equal(CGSize(width: fixtureCollectionViewBounds.width, height: fixtureCollectionViewBounds.height)))
                }
            }

            describe("layout attributes for elements in rect") {

                var layoutAttributes: [UICollectionViewLayoutAttributes]!

                beforeEach {
                        collectionViewMock.bounds = CGRect(x: fixtureCollectionViewBounds.x, y: fixtureCollectionViewBounds.y, width: fixtureCollectionViewBounds.width, height: fixtureCollectionViewBounds.height)
                        collectionViewMock.center = CGPoint(x: fixtureCollectionViewBounds.width / 2, y: fixtureCollectionViewBounds.height / 2)
                }

                context("when collection view has 2 items in first section") {

                    beforeEach {
                        collectionViewMock.numberOfItemsInSectionStub.on(equals(0), returnValue: 2)
                        layoutAttributes = sut.layoutAttributesForElementsInRect(CGRectZero)
                    }

                    it("should have layout attributes for 2 items") {
                        expect(layoutAttributes.count).to(equal(2))
                    }

                    describe("first item layout attributes") {

                        var firstItemLayoutAttributes: UICollectionViewLayoutAttributes!

                        beforeEach {
                            firstItemLayoutAttributes = layoutAttributes![0]
                        }

                        it("should have proper size") {
                            expect(firstItemLayoutAttributes.size).to(equal(CGSize(width: fixtureFirstItemAttributes.width, height: fixtureFirstItemAttributes.height)))
                        }
                        
                        it("should have proper item height to width ratio") {
                            let heightToWidhtRatio = firstItemLayoutAttributes.size.height / firstItemLayoutAttributes.size.width
                            expect(heightToWidhtRatio).to(equal(fixtureFirstItemAttributes.height / fixtureFirstItemAttributes.width))
                        }

                        it("should have proper center") {
                            expect(firstItemLayoutAttributes.center).to(equal(fixtureFirstItemAttributes.center))
                        }

                        it("should have proper z index") {
                            expect(firstItemLayoutAttributes.zIndex).to(equal(fixtureFirstItemAttributes.zIndex))
                        }
                    }

                    describe("second item layout attributes") {

                        var secondItemLayoutAttributes: UICollectionViewLayoutAttributes!

                        beforeEach {
                            secondItemLayoutAttributes = layoutAttributes![1]
                        }

                        it("should have proper size") {
                            expect(secondItemLayoutAttributes.size).to(equal(CGSize(width: fixtureSecondItemAttributes.width, height: fixtureSecondItemAttributes.height)))
                        }
                        
                        it("should have proper item height to width ratio") {
                            let heightToWidhtRatio = secondItemLayoutAttributes.size.height / secondItemLayoutAttributes.size.width
                            expect(heightToWidhtRatio).to(equal(fixtureSecondItemAttributes.height / fixtureSecondItemAttributes.width))
                        }

                        it("should have proper center") {
                            expect(secondItemLayoutAttributes.center).to(equal(fixtureSecondItemAttributes.center))
                        }

                        it("should have proper z index") {
                            expect(secondItemLayoutAttributes.zIndex).to(equal(fixtureSecondItemAttributes.zIndex))
                        }
                    }
                }
            }

            describe("should invalidate layout for bounds change") {

                var boundsChanged: Bool!

                beforeEach {
                    collectionViewMock.bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
                    boundsChanged = sut.shouldInvalidateLayoutForBoundsChange(CGRect(x: 0, y: 0, width: 200, height: 100))
                }

                it("should invalidate layout when bounds size changes") {
                    expect(boundsChanged).to(beTruthy())
                }
            }

            describe("initial layout attributes for appearing item") {

                var initialLayoutAttributes: UICollectionViewLayoutAttributes!

                beforeEach {
                    collectionViewMock.bounds = CGRect(x: fixtureCollectionViewBounds.x, y: fixtureCollectionViewBounds.y, width: fixtureCollectionViewBounds.width, height: fixtureCollectionViewBounds.height)
                    collectionViewMock.center = CGPoint(x: fixtureCollectionViewBounds.width / 2, y: fixtureCollectionViewBounds.height / 2)
                    collectionViewMock.numberOfItemsInSectionStub.on(0, returnValue: 1)
                    initialLayoutAttributes = sut.initialLayoutAttributesForAppearingItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should have proper size") {
                    expect(initialLayoutAttributes.size).to(equal(CGSize(width: fixtureFirstItemAttributes.width, height: fixtureFirstItemAttributes.height)))
                }

                it("should have proper center") {
                    expect(initialLayoutAttributes.center).to(equal(fixtureFirstItemAttributes.center))
                }

                it("should have proper z index") {
                    expect(initialLayoutAttributes.zIndex).to(equal(fixtureFirstItemAttributes.zIndex))
                }

                it("should have alpha 0") {
                    expect(initialLayoutAttributes.alpha).to(equal(fixtureFirstItemAttributes.alpha))
                }
            }

            describe("final layout attributes for appearing item") {

                var finalLayoutAttributes: UICollectionViewLayoutAttributes!

                beforeEach {
                    collectionViewMock.bounds = CGRect(x: fixtureCollectionViewBounds.x, y: fixtureCollectionViewBounds.y, width: fixtureCollectionViewBounds.width, height: fixtureCollectionViewBounds.height)
                    collectionViewMock.center = CGPoint(x: fixtureCollectionViewBounds.width / 2, y: fixtureCollectionViewBounds.height / 2)
                    collectionViewMock.numberOfItemsInSectionStub.on(0, returnValue: 1)
                    finalLayoutAttributes = sut.finalLayoutAttributesForDisappearingItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should have proper size") {
                    expect(finalLayoutAttributes.size).to(equal(CGSize(width: fixtureFirstItemAttributes.width, height: fixtureFirstItemAttributes.height)))
                }

                it("should have proper center") {
                    expect(finalLayoutAttributes.center).to(equal(CGPoint(x: fixtureCollectionViewBounds.width / 2, y: fixtureCollectionViewBounds.height + fixtureFirstItemAttributes.height)))
                }

                it("should have proper z index") {
                    expect(finalLayoutAttributes.zIndex).to(equal(fixtureFirstItemAttributes.zIndex))
                }

                it("should have alpha 0") {
                    expect(finalLayoutAttributes.alpha).to(equal(fixtureFirstItemAttributes.alpha))
                }
            }
        }
    }
}

private struct FixtureCollectionViewBounds {
    let width = CGFloat(320)
    let height = CGFloat(568)
    let x = CGFloat(0)
    let y = CGFloat(0)
}

private struct FixtureFirstItemAttributes {
    let width = CGFloat(265)
    let height = CGFloat(198.75)
    let center = CGPoint(x: 160, y: 284)
    let zIndex = 0
    let alpha = CGFloat(0)
}

private struct FixtureSecondItemAttributes  {
    let width = CGFloat(210)
    let height = CGFloat(157.5)
    let center = CGPoint(x: 160, y: 324)
    let zIndex = -1
    let alpha = CGFloat(0)
}
