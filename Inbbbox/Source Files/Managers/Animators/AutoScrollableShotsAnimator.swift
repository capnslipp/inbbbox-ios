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
    private let dataSources: [AutoScrollableShotsDataSource]
    private var collectionViewsToAnimate: [UICollectionView] {
        return dataSources.map { $0.collectionView }
    }
    
    private var displayLink: CADisplayLink?
    private var lastRunLoopTimestamp = CFTimeInterval(0)
    private var isAnimating = false
    private var extendedScrollableItemsCount = 0
    
    init(bindForAnimation array: [(collectionView: UICollectionView, shots: [UIImage])]) {
        
        for tuple in array {
            guard let _ = tuple.collectionView.superview else {
                fatalError("Given collection views have to be in view hierarchy! Add them to superview.")
            }
        }

        dataSources = array.map {
            AutoScrollableShotsDataSource(collectionView: $0.collectionView, content: $0.shots)
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidTick(_:)))
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
    
    func startScrollAnimationInfinitely() {
        
        if isAnimating {
            return
        }
        
        for dataSource in dataSources {
            dataSource.prepareForAnimation()
        }
        
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
        
        
        for (index, dataSource) in dataSources.enumerate() {
            
            let isEvenColumn = (index % 2 == 0)
            let direction = isEvenColumn ? 1 : -1 as CGFloat
            
            let verticalRescrollValueTop = CGFloat(dataSource.extendedScrollableItemsCount) * dataSource.itemSize.height
            let verticalRescrollValueBottom = dataSource.collectionView.contentSize.height - verticalRescrollValueTop
            
            var y = dataSource.collectionView.contentOffset.y + deltaY * direction
            
            if y >  verticalRescrollValueBottom && isEvenColumn {
                y = verticalRescrollValueTop
            }
            
            if y <  verticalRescrollValueTop && !isEvenColumn {
                y = verticalRescrollValueBottom
            }
            
            dataSource.collectionView.contentOffset = CGPoint(x: dataSource.collectionView.contentOffset.x, y: y)
        }
        
        lastRunLoopTimestamp = displayLink.timestamp
    }
}
