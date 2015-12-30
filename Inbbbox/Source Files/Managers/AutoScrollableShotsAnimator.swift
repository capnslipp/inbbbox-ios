//
//  AutoScrollableShotsAnimator.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit.UICollectionView

class AutoScrollableShotsAnimator {
    
    private let animationPointsPerSecond = CGFloat(50)
    private let collectionViewsToAnimate: [UICollectionView]
    private let dataSource = AutoScrollableShotsDataSource()
    
    private var displayLink: CADisplayLink?
    private var lastRunLoopTimestamp = CFTimeInterval(0)
    private var isAnimating = false
    
    init(collectionViewsToAnimate: [UICollectionView]) {
        self.collectionViewsToAnimate = collectionViewsToAnimate
        
        for collectionView in collectionViewsToAnimate {
            collectionView.dataSource = dataSource
            collectionView.delegate = dataSource
            dataSource.registerClassForCollectionView(collectionView)
        }
        
        displayLink = CADisplayLink(target: self, selector: "displayLinkDidTick:")
        displayLink?.frameInterval = 1
    }
    
    deinit {
        stopAnimation()
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
        
        if isAnimating {
            return
        }
        
        dataSource.fitExtendedScrollableContentCountForCollectionViews(collectionViewsToAnimate)
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        lastRunLoopTimestamp = displayLink?.timestamp ?? 0
        isAnimating = true
    }
    
    func stopAnimation() {
        displayLink?.invalidate()
        isAnimating = false
    }
    
    dynamic func displayLinkDidTick(_: CADisplayLink) {
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
