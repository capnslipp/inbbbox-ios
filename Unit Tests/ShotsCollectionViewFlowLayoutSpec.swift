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

        beforeEach {
            sut = ShotsCollectionViewFlowLayout()
            collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: sut!)
        }

        afterEach() {
            sut = nil
        }

        describe("prepare layout") {

            beforeEach {
                collectionView!.bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
                sut!.prepareLayout()
            }

            it("should have proper item size") {
                expect(sut!.itemSize).to(equal(CGSize(width: 320, height: 240)))
            }
            
            it("should have proper item height to width ratio") {
                let heightToWidhtRatio = sut!.itemSize.height / sut!.itemSize.width
                expect(heightToWidhtRatio).to(equal(3 / 4))
            }

            it("should have proper minimum line spacing") {
                expect(sut!.minimumLineSpacing).to(equal(CGFloat(427)))
            }

            it("should have proper section inset") {
                expect(sut!.sectionInset).to(equal(UIEdgeInsets(top: 214, left: 0, bottom: 214, right: 0)))
            }
        }
    }
}
