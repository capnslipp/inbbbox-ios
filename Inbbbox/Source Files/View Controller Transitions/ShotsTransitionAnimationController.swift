//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotsTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView()

        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)

        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)

        containerView!.addSubview(toView!)

        toView!.transform = CGAffineTransformTranslate(toView!.transform, CGFloat(0), -CGRectGetHeight(toView!.bounds))
        toView!.alpha = 0

//         NGRTemp: temporary implementation

        UIView.animateWithDuration(transitionDuration(transitionContext),
                delay: 0,
                options: UIViewAnimationOptions.LayoutSubviews,
                animations: {
                    toView!.transform = CGAffineTransformIdentity
                    toView!.alpha = 1
                }, completion: {
            (Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
