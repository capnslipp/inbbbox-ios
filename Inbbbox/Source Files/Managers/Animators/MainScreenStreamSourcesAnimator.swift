//
//  MainScreenStreamSourcesAnimator.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 27.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class MainScreenStreamSourcesAnimator {
    
    let view: ShotsCollectionBackgroundView
    var areStreamSourcesShown = false
    var isAnimationInProgress = false
    private let animationDuration: NSTimeInterval
    
    init(view: ShotsCollectionBackgroundView, animationDuration: NSTimeInterval = 0.2) {
        self.view = view
        self.animationDuration = animationDuration
    }
    
    /**
     Starts fade in animation of stream sources
     */
    func startFadeInAnimation() {
        if isAnimationInProgress == true {
            return
        }
        isAnimationInProgress = true
        view.prepareAnimatableContent()
        let options = UIViewAnimationOptions.CurveEaseInOut

        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouDefaultVerticalSpacing
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: options, animations: { [unowned self] in
            
            self.view.showingYouLabel.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoAnimationVerticalInset
        UIView.animateWithDuration(2 * animationDuration, delay: 0, options: options, animations: { [unowned self] in
            
            self.view.logoImageView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        let items = view.availableItems()
        for (index, item) in items.enumerate() {
            item.verticalSpacingConstraint?.constant = 0
            UIView.animateWithDuration(animationDuration, delay: Double(index + 1) * 0.1, options: options, animations: {
                    item.label.alpha = 1
                    item.label.layoutIfNeeded()
                }, completion: { [unowned self] _ in
                    if index == items.count - 1 {
                        self.areStreamSourcesShown = true
                        self.isAnimationInProgress = false
                    }
            })
        }
    }
    
    /**
     Starts fade out animation of stream sources
     */
    func startFadeOutAnimation() {
        if areStreamSourcesShown == false || isAnimationInProgress == true {
            return
        }
        isAnimationInProgress = true
        let options = UIViewAnimationOptions.CurveEaseInOut
        
        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouHiddenVerticalSpacing
        UIView.animateWithDuration(animationDuration, delay: 0.2, options: options, animations:    { [unowned self] in
                self.view.showingYouLabel.alpha = 0
                self.view.layoutIfNeeded()
        }, completion: nil)

        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoDefaultVerticalInset
        UIView.animateWithDuration(2 * animationDuration, delay: 0.1, options: options, animations:{ [unowned self] in
            self.view.logoImageView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let items = view.availableItems()
        for (index, item) in items.reverse().enumerate() {
            item.verticalSpacingConstraint?.constant = -5
            UIView.animateWithDuration(animationDuration, delay: Double(index) * 0.1, options: options, animations: {
                    item.label.alpha = 0
                    item.label.superview?.layoutIfNeeded()
                }, completion: { [unowned self] _ in
                    if index == items.count - 1 {
                        self.areStreamSourcesShown = false
                        self.isAnimationInProgress = false
                    }
            })
        }
    }
    
    /**
     Shows stream sources without animation
     */
    func showStreamSources() {
        view.prepareAnimatableContent()
        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouDefaultVerticalSpacing
        view.showingYouLabel.alpha = 1
        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoAnimationVerticalInset
        view.logoImageView.alpha = 0
        let items = view.availableItems()
        for item in items {
            item.verticalSpacingConstraint?.constant = 0
            item.label.alpha = 1
        }
        view.layoutIfNeeded()
        areStreamSourcesShown = true
    }
    
    /**
     Hides stream sources without animation
     */
    func hideStreamSources() {
        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouHiddenVerticalSpacing
        view.showingYouLabel.alpha = 0
        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoDefaultVerticalInset
        view.logoImageView.alpha = 1
        let items = view.availableItems()
        for item in items {
            item.verticalSpacingConstraint?.constant = -5
            item.label.alpha = 0
        }
        view.layoutIfNeeded()
        areStreamSourcesShown = false
    }
}
