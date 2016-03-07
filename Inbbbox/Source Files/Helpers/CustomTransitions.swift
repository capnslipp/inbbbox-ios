//
//  CustomTransitions.swift
//  Inbbbox
//
//  Created by Peter Bruz on 07/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import ZFDragableModalTransition

class CustomTransitions {
    
    class func pullDownToCloseTransitionForModalViewController(modalViewController: UIViewController, contentScrollView: UIScrollView) -> ZFModalTransitionAnimator {
        
        let modalTransitionAnimator = ZFModalTransitionAnimator(modalViewController: modalViewController)
        modalTransitionAnimator.dragable = true
        modalTransitionAnimator.direction = ZFModalTransitonDirection.Bottom
        modalTransitionAnimator.setContentScrollView(contentScrollView)
        modalTransitionAnimator.behindViewAlpha = 0.5
        
        return modalTransitionAnimator
    }
}
