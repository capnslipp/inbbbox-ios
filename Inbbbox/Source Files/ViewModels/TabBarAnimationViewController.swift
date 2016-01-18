//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TabBarAnimationViewController: UIViewController, PresentationStepViewController {

    private var didSetInitialTabbarPosition = false
    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate?
    var tabBarAnimationView: TabBarAnimationView {
        return view as! TabBarAnimationView
    }

//    MARK: - UIViewController

    override func loadView() {
        view = TabBarAnimationView(frame: CGRectZero)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !didSetInitialTabbarPosition {
            let tabBarHeight = tabBarAnimationView.tabBar.intrinsicContentSize().height
            tabBarAnimationView.tabBarVerticalConstraint?.constant = tabBarHeight
            tabBarAnimationView.tabBar.likesItemViewVerticalConstraint?.constant = tabBarHeight
            tabBarAnimationView.tabBar.bucketsItemViewVerticalConstraint?.constant = tabBarHeight
            tabBarAnimationView.tabBar.followingItemViewVerticalConstraint?.constant = tabBarHeight
            tabBarAnimationView.tabBar.accountItemViewVerticalConstraint?.constant = tabBarHeight

            didSetInitialTabbarPosition = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        NGRTemp: temporary implementation
    
        UIView.animateWithDuration(0.3, animations: {
            self.tabBarAnimationView.tabBarVerticalConstraint?.constant = 0
            self.tabBarAnimationView.layoutIfNeeded()
        }, completion: { finished in
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: .LayoutSubviews, animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: {
                    self.tabBarAnimationView.tabBar.likesItemViewVerticalConstraint?.constant = 0
                    self.tabBarAnimationView.layoutIfNeeded()
                })
                UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.25, animations: {
                    self.tabBarAnimationView.tabBar.bucketsItemViewVerticalConstraint?.constant = 0
                    self.tabBarAnimationView.layoutIfNeeded()
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.25, animations: {
                    self.tabBarAnimationView.tabBar.followingItemViewVerticalConstraint?.constant = 0
                    self.tabBarAnimationView.layoutIfNeeded()
                })
                UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
                    self.tabBarAnimationView.tabBar.accountItemViewVerticalConstraint?.constant = 0
                    self.tabBarAnimationView.layoutIfNeeded()
                })
            }, completion: { finished in
//            self.presentationStepViewControllerDelegate?.presentationStepViewControllerDidFinishPresenting(self)
            })
        })
    }

//    MARK: - PresentationStepViewController

    var viewController: UIViewController {
        return self
    }
}
