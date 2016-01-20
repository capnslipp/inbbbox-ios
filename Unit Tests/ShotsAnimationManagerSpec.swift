//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

@testable import Inbbbox

class ShotsAnimationManagerSpec: QuickSpec {

    override func spec() {

        var sut: ShotsAnimationManager?

        beforeEach {
            sut = ShotsAnimationManager()
        }

        afterEach {
            sut = nil
        }

        describe("start animation with completion") {

            var capturedAddedItemsIndexPaths: [NSIndexPath]?
            var capturedDeletedItemsIndexPaths: [NSIndexPath]?
            var capturedDelays: [Double]?
            var didInvokeCompletion: Bool?

            beforeEach {
                capturedAddedItemsIndexPaths = [NSIndexPath]()
                capturedDeletedItemsIndexPaths = [NSIndexPath]()
                capturedDelays = [Double]()

                let collectionViewMock = CollectionViewMock(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionViewMock.insertItemsAtIndexPathsStub.on(any()) { indexPaths in
                    capturedAddedItemsIndexPaths!.append(indexPaths.first!)
                }
                collectionViewMock.deleteItemsAtIndexPathsStub.on(any()) { indexPaths in
                    capturedDeletedItemsIndexPaths!.append(indexPaths.first!)
                }
                collectionViewMock.performBatchUpdatesStub.on(any()) { updates, completion in
                    updates?()
                    completion?(true)
                }

                let delegateMock = ShotsAnimationManagerDelegateMock()
                delegateMock.collectionViewForAnimationManagerStub.on(any(), returnValue: collectionViewMock)
                delegateMock.itemsForAnimationManagerStub.on(any(), returnValue: ["fixtureShot1", "fixtureShot2", "fixtureShot3"])
                sut!.delegate = delegateMock

                let asyncWrapperMock = AsyncWrapperMock()
                asyncWrapperMock.mainStub.on(any()) { after, block in
                    capturedDelays!.append(after!)
                    block()
                    return asyncWrapperMock
                }

                sut!.asyncWrapper = asyncWrapperMock

                sut!.startAnimationWithCompletion() {
                    didInvokeCompletion = true
                }
            }

            describe("adding items") {

                it("should add 3 items") {
                    expect(capturedAddedItemsIndexPaths!.count).to(equal(3))
                }

                describe("first added item") {

                    var addedItemIndexPath: NSIndexPath?
                    var addedItemDelay: Double?

                    beforeEach {
                        addedItemIndexPath = capturedAddedItemsIndexPaths![0]
                        addedItemDelay = capturedDelays![0]
                    }

                    it("should add item for proper index path") {
                        expect(addedItemIndexPath!).to(equal(NSIndexPath(forItem: 0, inSection: 0)))
                    }

                    it("should add item with proper delay") {
                        expect(addedItemDelay).to(beCloseTo(0.1))
                    }
                }

                describe("second added item") {

                    var addedItemIndexPath: NSIndexPath?
                    var addedItemDelay: Double?

                    beforeEach {
                        addedItemIndexPath = capturedAddedItemsIndexPaths![1]
                        addedItemDelay = capturedDelays![1]
                    }

                    it("should add item for proper index path") {
                        expect(addedItemIndexPath!).to(equal(NSIndexPath(forItem: 1, inSection: 0)))
                    }

                    it("should add item with proper delay") {
                        expect(addedItemDelay).to(beCloseTo(0.2))
                    }
                }

                describe("third added item") {

                    var addedItemIndexPath: NSIndexPath?
                    var addedItemDelay: Double?

                    beforeEach {
                        addedItemIndexPath = capturedAddedItemsIndexPaths![2]
                        addedItemDelay = capturedDelays![2]
                    }

                    it("should add item for proper index path") {
                        expect(addedItemIndexPath!).to(equal(NSIndexPath(forItem: 2, inSection: 0)))
                    }

                    it("should add item with proper delay") {
                        expect(addedItemDelay).to(beCloseTo(0.3))
                    }
                }
            }

            describe("deleting items") {

                it("should delete 2 items") {
                    expect(capturedDeletedItemsIndexPaths!.count).to(equal(2))
                }

                it("should make 1 second pause before deleting items"){
                    expect(capturedDelays![3]).to(beCloseTo(1.0))
                }

                describe("first deleted item") {

                    var deletedItemIndexPath: NSIndexPath?
                    var deletedItemDelay: Double?

                    beforeEach {
                        deletedItemIndexPath = capturedDeletedItemsIndexPaths![0]
                        deletedItemDelay = capturedDelays![4]
                    }

                    it("should delete item for proper index path") {
                        expect(deletedItemIndexPath!).to(equal(NSIndexPath(forItem: 2, inSection: 0)))
                    }

                    it("should delete item with proper delay") {
                        expect(deletedItemDelay).to(beCloseTo(0.1))
                    }
                }

                describe("second deleted item") {

                    var deletedItemIndexPath: NSIndexPath?
                    var deletedItemDelay: Double?

                    beforeEach {
                        deletedItemIndexPath = capturedDeletedItemsIndexPaths![1]
                        deletedItemDelay = capturedDelays![5]
                    }

                    it("should delete item for proper index path") {
                        expect(deletedItemIndexPath!).to(equal(NSIndexPath(forItem: 1, inSection: 0)))
                    }

                    it("should delete item with proper delay") {
                        expect(deletedItemDelay).to(beCloseTo(0.2))
                    }
                }

                it("should invoke completion") {
                    expect(didInvokeCompletion).to(beTruthy())
                }
            }
        }
    }
}
