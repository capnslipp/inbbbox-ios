//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Dobby

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

            var animationManagerMock: InitialShotsAnimationManagerMock?
            var capturedCompletion: (Void -> Void)?

            beforeEach() {
                animationManagerMock = InitialShotsAnimationManagerMock()
                animationManagerMock!.startAnimationWithCompletionStub.on(any()) {
                    completion in
                    capturedCompletion = completion
                }
                sut!.animationManager = animationManagerMock!
                sut!.viewDidAppear(true)
            }

            describe("animation completion") {

                var delegateMock: InitialShotsCollectionViewLayoutDelegateMock?

                beforeEach() {
                    delegateMock = InitialShotsCollectionViewLayoutDelegateMock()
                    delegateMock!.initialShotsCollectionViewDidFinishAnimationsMock.expect(any())
                    sut!.delegate = delegateMock
                    capturedCompletion!()
                }

                it("should inform delegate that collection view animations did finish") {
                    delegateMock!.initialShotsCollectionViewDidFinishAnimationsMock.verify()
                }
            }
        }
    }
}
