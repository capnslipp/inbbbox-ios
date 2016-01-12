//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TabBarAnimationViewController: UIViewController, PresentationStepViewController {

    weak var presentationStepViewControllerDelegate: PresentationStepViewControllerDelegate?
    var tabBarAnimationView: TabBarAnimationView {
        return view as! TabBarAnimationView
    }

//    MARK: - UIViewController

    override func loadView() {
        view = TabBarAnimationView(frame: CGRectZero)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        NGRTemp: temporary implementation

        let tabBarHeight = tabBarAnimationView.tabBar.intrinsicContentSize().height
        tabBarAnimationView.tabBarVerticalConstraint?.constant -= tabBarHeight

        UIView.animateWithDuration(1, animations: {
            self.tabBarAnimationView.layoutIfNeeded()
        }, completion: { finished in
//            self.presentationStepViewControllerDelegate?.presentationStepViewControllerDidFinishPresenting(self)
        })
    }

//    MARK: - PresentationStepViewController

    var viewController: UIViewController {
        return self
    }
}
