//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarController: UITabBarController {

    private var didSetConstraints = false
    let centerButton = RoundedButton()
    let shotsCollectionViewController = ShotsCollectionViewController()
    var didUpdateTabBarItems = false
    
    enum CenterButtonViewControllers: Int {
        case Likes = 0
        case Buckets = 1
        case Shots = 2
        case Followees = 3
        case Accounts = 4
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        
        let likesViewController = UINavigationController(rootViewController: LikesCollectionViewController(oneColumnLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio, twoColumnsLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio))
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

        tabBar.layer.shadowColor = UIColor(white: 0, alpha: 0.03).CGColor
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowOpacity = 0.6
        
        _ =  { // these two lines hide top border line of tabBar - can't be separated, so I packed them into closure
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }()
        
        tabBar.translucent = false
        centerButton.configureForAutoLayout()
        centerButton.setImage(UIImage(named: "ic-ball-active"), forState: .Selected)
        centerButton.setImage(UIImage(named: "ic-ball-inactive"), forState: .Normal)
        centerButton.backgroundColor = UIColor.whiteColor()
        centerButton.layer.zPosition = 1;
        centerButton.addTarget(self, action: "didTapCenterButton:", forControlEvents: .TouchUpInside)
        tabBar.addSubview(centerButton)
        centerButton.autoAlignAxisToSuperviewAxis(.Vertical)
        centerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 8.0)
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let items = tabBar.items where !didUpdateTabBarItems {
            didUpdateTabBarItems = true
            for tabBarItem in items {
                tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
            }
        }
        tabBar.bringSubviewToFront(centerButton)
        centerButton.selected = true
    }

//    MARK: - Actions

    func didTapCenterButton(_: UIButton) {
        centerButton.selected = true
        selectedViewController = shotsCollectionViewController
    }
}

extension CenterButtonTabBarController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if (selectedIndex != CenterButtonViewControllers.Shots.rawValue) {
            centerButton.selected = false
        }
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
