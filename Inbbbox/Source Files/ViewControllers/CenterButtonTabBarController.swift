//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarController: UITabBarController {

    private var didSetConstraints = false
    let centerButton = RoundedButton()
    private(set) var shotsViewController: UIViewController?

    convenience init(shotsViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)

        self.shotsViewController = shotsViewController

        let likesViewController = UIViewController()
        likesViewController.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(named: "ic-likes"), selectedImage: UIImage(named: "ic-likes-active"))
        let bucketsViewController = UIViewController()
        bucketsViewController.tabBarItem = UITabBarItem(title: "Buckets", image: UIImage(named: "ic-buckets"), selectedImage: UIImage(named: "ic-buckets-active"))
        let followingViewController = UIViewController()
        followingViewController.tabBarItem = UITabBarItem(title: "Following", image: UIImage(named: "ic-following"), selectedImage: UIImage(named: "ic-following-active"))
        let accountViewController = UIViewController()
        accountViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "ic-account"), selectedImage: UIImage(named: "ic-account-active"))
        viewControllers = [likesViewController, bucketsViewController, shotsViewController, followingViewController, accountViewController]
        selectedViewController = shotsViewController
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        centerButton.configureForAutoLayout()
        centerButton.setImage(UIImage(named: "ic-ball-active"), forState: .Normal)
        centerButton.backgroundColor = UIColor.whiteColor()
        centerButton.layer.zPosition = 1;
        centerButton.addTarget(self, action: "didTapCenterButton:", forControlEvents: .TouchUpInside)
        tabBar.addSubview(centerButton)
        centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
        centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 8.0)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tabBar.bringSubviewToFront(centerButton)
    }

//    MARK: - Actions

    func didTapCenterButton(button: UIButton) {
        selectedViewController = shotsViewController
    }
}
