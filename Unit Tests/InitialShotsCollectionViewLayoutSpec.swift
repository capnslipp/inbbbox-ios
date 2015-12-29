//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class InitialShotsCollectionViewLayoutSpec: QuickSpec {

    override func spec() {

        var sut: InitialShotsCollectionViewLayout?
        var collectionViewMock: CollectionViewMock?

        beforeEach() {
            sut = InitialShotsCollectionViewLayout()
            collectionViewMock = CollectionViewMock(frame: CGRectZero, collectionViewLayout: sut!)
        }

        afterEach() {
            sut = nil
        }

        describe("collection view layout") {

            describe("collection view content size") {

                var contentSize: CGSize?

                beforeEach() {
                    collectionViewMock!.bounds = CGRect(x: 0, y: 0, width: 42, height: 666)
                    contentSize = sut!.collectionViewContentSize()
                }

                it("should have proper content size") {
                    expect(contentSize).to(equal(CGSize(width: 42, height: 666)))
                }
            }

            describe("layout attributes for elements in rect") {

                var layoutAttributes: [UICollectionViewLayoutAttributes]?

                beforeEach() {
                    collectionViewMock!.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
                    collectionViewMock!.center = CGPoint(x: 100, y: 100)
                }

                context("when collection view has 2 items in first section") {

                    beforeEach() {
                        collectionViewMock!.numberOfItemsInSectionStub.on(0, returnValue: 2)
                        layoutAttributes = sut!.layoutAttributesForElementsInRect(CGRectZero)
                    }

                    it("should have layout attributes for 2 items") {
                        expect(layoutAttributes!.count).to(equal(2))
                    }

                    describe("first item layout attributes") {

                        var firstItemLayoutAttributes: UICollectionViewLayoutAttributes?

                        beforeEach() {
                            firstItemLayoutAttributes = layoutAttributes![0]
                        }

                        it("should have proper size") {
                            expect(firstItemLayoutAttributes!.size).to(equal(CGSize(width: 144, height: ShotCollectionViewCell.prefferedHeight)))
                        }

                        it("should have proper center") {
                            expect(firstItemLayoutAttributes!.center).to(equal(CGPoint(x: 100, y: 100)))
                        }

                        it("should have proper z index") {
                            expect(firstItemLayoutAttributes!.zIndex).to(equal(0))
                        }
                    }

                    describe("second item layout attributes") {

                        var firstItemLayoutAttributes: UICollectionViewLayoutAttributes?

                        beforeEach() {
                            firstItemLayoutAttributes = layoutAttributes![1]
                        }

                        it("should have proper size") {
                            expect(firstItemLayoutAttributes!.size).to(equal(CGSize(width: 88, height: ShotCollectionViewCell.prefferedHeight)))
                        }

                        it("should have proper center") {
                            expect(firstItemLayoutAttributes!.center).to(equal(CGPoint(x: 100, y: 120)))
                        }

                        it("should have proper z index") {
                            expect(firstItemLayoutAttributes!.zIndex).to(equal(-1))
                        }
                    }
                }
            }

            describe("should invalidate layout for bounds change") {

                var boundsChanged: Bool?

                beforeEach() {
                    collectionViewMock!.bounds = CGRect(x: 0, y: 0, width: 100, height: 200)
                    boundsChanged = sut!.shouldInvalidateLayoutForBoundsChange(CGRect(x: 0, y: 0, width: 200, height: 100))
                }

                it("should invalidate layout when bounds size changes") {
                    expect(boundsChanged).to(beTruthy())
                }
            }

            describe("initial layout attributes for appearing item") {

                var initialLayoutAttributes: UICollectionViewLayoutAttributes?

                beforeEach() {
                    collectionViewMock!.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
                    collectionViewMock!.center = CGPoint(x: 100, y: 100)
                    collectionViewMock!.numberOfItemsInSectionStub.on(0, returnValue: 1)
                    initialLayoutAttributes = sut!.initialLayoutAttributesForAppearingItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should have proper size") {
                    expect(initialLayoutAttributes!.size).to(equal(CGSize(width: 144, height: ShotCollectionViewCell.prefferedHeight)))
                }

                it("should have proper center") {
                    expect(initialLayoutAttributes!.center).to(equal(CGPoint(x: 100, y: 100)))
                }

                it("should have proper z index") {
                    expect(initialLayoutAttributes!.zIndex).to(equal(0))
                }
            }

            describe("final layout attributes for appearing item") {

                var finalLayoutAttributes: UICollectionViewLayoutAttributes?

                beforeEach() {
                    collectionViewMock!.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
                    collectionViewMock!.center = CGPoint(x: 100, y: 100)
                    collectionViewMock!.numberOfItemsInSectionStub.on(0, returnValue: 1)
                    finalLayoutAttributes = sut!.finalLayoutAttributesForDisappearingItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should have proper size") {
                    expect(finalLayoutAttributes!.size).to(equal(CGSize(width: 144, height: ShotCollectionViewCell.prefferedHeight)))
                }

                it("should have proper center") {
                    expect(finalLayoutAttributes!.center).to(equal(CGPoint(x: 100, y: 440)))
                }

                it("should have proper z index") {
                    expect(finalLayoutAttributes!.zIndex).to(equal(0))
                }
            }
        }
    }
}
