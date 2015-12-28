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
        }
    }
}
