//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

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

        it("should have shots collection view flow layout") {
            expect(sut.collectionViewLayout).to(beAKindOf(ShotsCollectionViewFlowLayout))
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

        describe("collection view data source") {

            describe("cell for item at index path") {

                var item: UICollectionViewCell!

                beforeEach{
                    item = sut.collectionView(sut.collectionView!, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                }

                it("should dequeue shot collection view cell"){
                    expect(item).to(beAKindOf(ShotCollectionViewCell))
                }
            }
        }
    }
}
