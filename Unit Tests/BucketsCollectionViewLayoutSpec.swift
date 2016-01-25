//
//  BucketsCollectionViewLayoutSpec.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class BucketsCollectionViewLayoutSpec: QuickSpec {
    
    override func spec() {
        
        var sut: BucketsCollectionViewLayout?
        var collectionView: UICollectionView?
        var widthDependendSpacing: CGFloat?
        
        beforeEach {
            sut = BucketsCollectionViewLayout()
            collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: sut!)
        }
        
        afterEach() {
            sut = nil
        }
        
        describe("prepare layout") {
            
            beforeEach {
                collectionView!.bounds = CGRect(x:0, y:0, width:500, height:500)
                widthDependendSpacing = CGFloat((CGRectGetWidth(collectionView!.bounds) - 2 * BucketCollectionViewCell.prefferedWidth) / 3)
                sut!.prepareLayout()
            }
            
            it("should have proper item size") {
                expect(sut!.itemSize).to(equal(CGSize(width: BucketCollectionViewCell.prefferedWidth, height: BucketCollectionViewCell.prefferedHeight)))
            }
            
            it("should have proper minimum line spacing") {
                expect(sut!.minimumLineSpacing).to(equal(widthDependendSpacing!))
            }
            
            it("should have proper section inset") {
                expect(sut!.sectionInset).to(equal(UIEdgeInsets(top: widthDependendSpacing!, left: widthDependendSpacing!, bottom: widthDependendSpacing!, right: widthDependendSpacing!)))
            }
        }
    }
}
