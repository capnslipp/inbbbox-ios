//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarController: UITabBarController {

    private var didSetConstraints = false
    let centerButton = RoundedButton()

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        centerButton.configureForAutoLayout()
        centerButton.setImage(UIImage(named: "ic-ball-active"), forState: .Normal)
        centerButton.backgroundColor = UIColor.whiteColor()
        tabBar.addSubview(centerButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //        NGRTemp: temporary implementation

        if !didSetConstraints {
            centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
            centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset:8.0)

            didSetConstraints = true
        }
    }
}
