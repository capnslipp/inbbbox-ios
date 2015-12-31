//
//  AutoScrollableShotsAnimatorSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 31/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class AutoScrollableShotsAnimatorSpec: QuickSpec {
    override func spec() {
        
        var sut: AutoScrollableShotsAnimator!
        var collectionViews: [UICollectionView]! // keep reference to be able to check expectation
        let content =  [
            UIImage.referenceImageWithColor(.greenColor()),
            UIImage.referenceImageWithColor(.yellowColor()),
            UIImage.referenceImageWithColor(.redColor())
        ]
        var mockSuperview: UIView!
        
        beforeEach {
            let collectionView_1 = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 200), collectionViewLayout: UICollectionViewFlowLayout())
            let collectionView_2 = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 200), collectionViewLayout: UICollectionViewFlowLayout())
            
            collectionViews = [collectionView_1, collectionView_2]
            let bindForAnimation = collectionViews.map {
                (collectionView: $0, shots: content)
            }
            
            mockSuperview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            mockSuperview.addSubview(collectionView_1)
            mockSuperview.addSubview(collectionView_2)

            sut = AutoScrollableShotsAnimator(bindForAnimation: bindForAnimation)
        }
        
        afterEach {
            sut = nil
            collectionViews = nil
            mockSuperview = nil
        }
        
        it("when newly created, content offset should be 0") {
            expect(collectionViews.map{ $0.contentOffset }).to(equal([CGPointZero, CGPointZero]))
        }
        
        describe("when scrolling to middle") {
            
            beforeEach {
                sut.scrollToMiddleInstantly()
            }
            
            it("collection views should be in the middle") {
                let middlePoint = CGPoint(x: 0, y: -100)
                expect(collectionViews.map{ $0.contentOffset }).to(equal([middlePoint, middlePoint]))
            }
        }
        
        describe("when performing scroll animation") {
            
            beforeEach {
                sut.startScrollAnimationInfinitely()
            }
            
            afterEach {
                sut.stopAnimation()
            }
            
            it("first collection view should be scrolled up") {
                
                let initialValueY = collectionViews[0].contentOffset.y
                
                waitThenContinue()
                expect(collectionViews[0].contentOffset.y).to(beGreaterThan(initialValueY))
            }
            
            it("second collection view should be scrolled down") {
                
                let initialValueY = collectionViews[1].contentOffset.y
                
                waitThenContinue()
                expect(collectionViews[1].contentOffset.y).to(beLessThan(initialValueY))
            }
            
            context("and stopping it") {
                
                beforeEach {
                    sut.stopAnimation()
                }
                
                it("first collection view should be in same place") {
                    
                    let initialValueY = collectionViews[0].contentOffset.y
                    
                    waitThenContinue()
                    expect(collectionViews[0].contentOffset.y).to(equal(initialValueY))
                }
                
                it("second collection view should be in same place") {
                    
                    let initialValueY = collectionViews[1].contentOffset.y
                    
                    waitThenContinue()
                    expect(collectionViews[1].contentOffset.y).to(equal(initialValueY))
                }
            }
        }
    }
}
