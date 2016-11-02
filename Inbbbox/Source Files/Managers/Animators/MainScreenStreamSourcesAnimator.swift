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
    private let animationDuration: NSTimeInterval = 0.2
    
    init(view: ShotsCollectionBackgroundView) {
        self.view = view
    }
    
    func startFadeInAnimation() {
        if isAnimationInProgress == true {
            return
        }
        isAnimationInProgress = true
        view.prepareAnimatableContent()
        let options = UIViewAnimationOptions.CurveEaseInOut

        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouDefaultVerticalSpacing
        UIView.animate(duration: animationDuration, animations: { [unowned self] in
            self.view.showingYouLabel.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoAnimationVerticalInset
        UIView.animate(duration: 0.4, animations: { [unowned self] in
            self.view.logoImageView.alpha = 0
            self.view.layoutIfNeeded()
            })
        let items = view.availableItems()
        for (index, item) in items.enumerate() {
            item.verticalSpacingConstraint?.constant = 0
            UIView.animateWithDuration(0.2, delay: Double(index + 1) * 0.1, options: options, animations: {
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
    
    func startFadeOutAnimation() {
        if areStreamSourcesShown == false || isAnimationInProgress == true {
            return
        }
        isAnimationInProgress = true
        
        view.showingYouVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.showingYouHiddenVerticalSpacing
        UIView.animateWithDuration(animationDuration, delay: 0.2, options: .CurveLinear, animations:    { [unowned self] in
                self.view.showingYouLabel.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)

        view.logoVerticalConstraint?.constant = ShotsCollectionBackgroundViewSpacing.logoDefaultVerticalInset
        UIView.animateWithDuration(0.4, delay: 0.1, options: .CurveLinear, animations:{ [unowned self] in
            self.view.logoImageView.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        let items = view.availableItems()
        for (index, item) in items.reverse().enumerate() {
            item.verticalSpacingConstraint?.constant = -5
            UIView.animateWithDuration(animationDuration, delay: Double(index) * 0.1, options: .CurveLinear, animations: {
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
}
