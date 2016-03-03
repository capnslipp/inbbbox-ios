//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarController: UITabBarController {

    private var didSetConstraints = false
    let centerButton = RoundedButton()
    let shotsCollectionViewController = ShotsCollectionViewController()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        let likesViewController = UINavigationController(rootViewController: LikesCollectionViewController(oneColumnLayoutCellHeightToWidthRatio: LikeCollectionViewCell.heightToWidthRatio, twoColumnsLayoutCellHeightToWidthRatio: LikeCollectionViewCell.heightToWidthRatio))
        likesViewController.tabBarItem = tabBarItemWithTitle(NSLocalizedString("Likes", comment: ""), imageName: "ic-likes")
        let bucketsViewController = UINavigationController(rootViewController: BucketsCollectionViewController())
        bucketsViewController.tabBarItem = tabBarItemWithTitle(NSLocalizedString("Buckets", comment: ""), imageName: "ic-buckets")
        let followeesViewController = UINavigationController(rootViewController: FolloweesCollectionViewController(oneColumnLayoutCellHeightToWidthRatio: LargeFolloweeCollectionViewCell.heightToWidthRatio, twoColumnsLayoutCellHeightToWidthRatio: SmallFolloweeCollectionViewCell.heightToWidthRatio))
        followeesViewController.tabBarItem = tabBarItemWithTitle(NSLocalizedString("Following", comment: ""), imageName: "ic-following")
        let accountViewController = UINavigationController(rootViewController: SettingsViewController())
        accountViewController.tabBarItem = tabBarItemWithTitle(NSLocalizedString("Account", comment: ""), imageName: "ic-account")
        
        viewControllers = [likesViewController, bucketsViewController, shotsCollectionViewController, followeesViewController, accountViewController]
        selectedViewController = shotsCollectionViewController
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOpacity = 1
        
        _ =  { // these two lines hide top border line of tabBar - can't be separated, so I packed them into closure
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }()
        
        tabBar.translucent = false
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

    func didTapCenterButton(_: UIButton) {
        selectedViewController = shotsCollectionViewController
    }
}

private extension CenterButtonTabBarController {
    
    func tabBarItemWithTitle(title: String, imageName: String) -> UITabBarItem {
        
        let image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: imageName + "-active")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.pinkColor()], forState: .Selected)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.tabBarGrayColor()], forState: .Normal)
        
        return tabBarItem
    }
    
}
