//
//  AutoScrollableShotsAnimator.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit.UICollectionView

class AutoScrollableShotsAnimator: NSObject {
    
    private let animationPointsPerSecond = CGFloat(50)
    private let collectionViewsToAnimate: [UICollectionView]
    private let dataSource = AutoScrollableShotsDataSource()
    
    private var displayLink: CADisplayLink?
    private var lastRunLoopTimestamp = CFTimeInterval(0)
    
    init(collectionViewsToAnimate: [UICollectionView]) {
        self.collectionViewsToAnimate = collectionViewsToAnimate
        
        for collectionView in collectionViewsToAnimate {
            collectionView.dataSource = dataSource
            collectionView.delegate = dataSource
            dataSource.registerClassForCollectionView(collectionView)
        }
        
        super.init()
        
        displayLink = CADisplayLink(target: self, selector: "displayLinkDidTick:")
        displayLink?.frameInterval = 1
    }
    
    func scrollToMiddleInstantly() {
        
        for collectionView in collectionViewsToAnimate {
            
            let contentOffset = CGPoint(
                x: 0,
                y: collectionView.contentSize.height * 0.5 - CGRectGetHeight(collectionView.superview!.bounds) * 0.5
            )
            collectionView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    func startScrollAnimationIndefinitely() {
        
        dataSource.fitExtendedScrollableContentCountForCollectionViews(collectionViewsToAnimate)
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        lastRunLoopTimestamp = displayLink?.timestamp ?? 0
    }
    
    func stopAnimation() {
        displayLink?.invalidate()
    }
    
    func displayLinkDidTick(_: CADisplayLink) {
        performScrollAnimation()
    }
}

private extension AutoScrollableShotsAnimator {
    
    func performScrollAnimation() {
        
        guard let displayLink = displayLink else {
            return
        }
        
        let deltaY = CGFloat(animationPointsPerSecond) * CGFloat(displayLink.timestamp - lastRunLoopTimestamp)
        
        for (index, collectionView) in collectionViewsToAnimate.enumerate() {
            
            let isEvenColumn = (index % 2 == 0)
            let direction = isEvenColumn ? 1 : -1 as CGFloat
            
            let verticalRescrollValueTop = CGFloat(dataSource.extendedScrollableContentCount) * dataSource.sizeForItemInCollectionView(collectionView).height
            let verticalRescrollValueBottom = collectionView.contentSize.height - verticalRescrollValueTop
            
            var y = collectionView.contentOffset.y + deltaY * direction
            
            if y >  verticalRescrollValueBottom && isEvenColumn {
                y = verticalRescrollValueTop
            }
            
            if y <  verticalRescrollValueTop && !isEvenColumn {
                y = verticalRescrollValueBottom
            }

            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: y)
            
        }
        
        lastRunLoopTimestamp = displayLink.timestamp
    }
}
