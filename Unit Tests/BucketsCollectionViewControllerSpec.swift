//
//  BucketsCollectionViewControllerSpec.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class BucketsCollectionViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var sut: BucketsCollectionViewController!
        
        beforeEach {
            sut = BucketsCollectionViewController()
        }
        
        afterEach() {
            sut = nil
        }
        
        it("should have initial shots collection view layout") {
            expect(sut.collectionViewLayout).to(beAKindOf(BucketsCollectionViewLayout))
        }
        
        describe("when view did load") {
            
            describe("collection view") {
                
                var collectionView: UICollectionView!
                
                beforeEach {
                    collectionView = sut.collectionView
                }
                
                it("should have paging disabled") {
                    expect(collectionView.pagingEnabled).to(beFalsy())
                }
                
                it("should have proper background view") {
                    expect(collectionView.backgroundColor).to(equal(UIColor.backgroundGrayColor()))
                }
            }
        }
            
        describe("collection view data source") {
            
            describe("cell for item at index path") {
                
                var item: UICollectionViewCell!
                
                beforeEach {
                    item = sut.collectionView(sut.collectionView!, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                }
                
                it("should dequeue bucket collection view cell") {
                    expect(item).to(beAKindOf(BucketCollectionViewCell))
                }
                
                it("should dequeue cell with proper identifier") {
                    expect(item.reuseIdentifier).to(equal("BucketCollectionViewCellIdentifier"))
                }
            }
        }
    }
}
