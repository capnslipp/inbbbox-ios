//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class ShotsCollectionViewFlowLayoutSpec: QuickSpec {
    override func spec() {

        var sut: ShotsCollectionViewFlowLayout?
        var collectionView: UICollectionView?

        beforeEach() {
            sut = ShotsCollectionViewFlowLayout()
            collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: sut!)
        }

        afterEach() {
            sut = nil
        }

        describe("prepare layout") {

            beforeEach() {
                collectionView!.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
                sut!.prepareLayout()
            }

            it("should have proper item size") {
                expect(sut!.itemSize).to(equal(CGSize(width: 444, height: ShotCollectionViewCell.prefferedHeight)))
            }

            it("should have proper minimum line spacing") {
                expect(sut!.minimumLineSpacing).to(equal(CGFloat(260)))
            }

            it("should have proper section inset") {
                expect(sut!.sectionInset).to(equal(UIEdgeInsets(top: 130, left: 0, bottom: 130, right: 0)))
            }
        }
    }
}
