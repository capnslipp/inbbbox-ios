//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class InitialShotsCollectionViewControllerSpec: QuickSpec {
    override func spec() {

        var sut: InitialShotsCollectionViewController?

        beforeEach() {
            sut = InitialShotsCollectionViewController()
        }

        afterEach() {
            sut = nil
        }

        it("should have initial shots collection view layout") {
            expect(sut!.collectionViewLayout).to(beAKindOf(InitialShotsCollectionViewLayout))
        }

        it("should have animation manager") {
            expect(sut!.animationManager).toNot(beNil())
        }

        describe("view did load") {

            beforeEach() {
                sut!.view
            }

            describe("collection view") {

                var collectionView: UICollectionView?

                beforeEach() {
                    collectionView = sut!.collectionView
                }

                it("should have paging enabled") {
                    expect(collectionView!.pagingEnabled).to(beTruthy())
                }
            }
        }

        describe("view did appear") {

            beforeEach() {
                sut!.viewDidAppear(true)
            }

//            NGRTodo: Find mocking pod
        }
    }
}
