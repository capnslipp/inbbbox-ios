//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CenterButtonTabBarController: UITabBarController {

    private var didSetConstraints = false
    let centerButton = RoundedButton()
    let shotsCollectionViewController = ShotsCollectionViewController()
    let settingsViewController = SettingsViewController()
    var didUpdateTabBarItems = false
    var animatableLikesTabBarItem: UIImageView?
    var animatableBucketsTabBarItem: UIImageView?

    enum CenterButtonViewControllers: Int {
        case Likes = 0
        case Buckets = 1
        case Shots = 2
        case Followees = 3
        case Accounts = 4
    }

    override var selectedIndex: Int {
        didSet {
            centerButton.selected = selectedViewController == shotsCollectionViewController
        }
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        let likesViewController = UINavigationController(
            rootViewController: SimpleShotsCollectionViewController()
        )
        
        let currentColorMode = ColorModeProvider.current()
        likesViewController.tabBarItem = tabBarItemWithTitle(
            NSLocalizedString("CenterButtonTabBar.Likes", comment: "Main view, bottom bar"),
            normalImageName: currentColorMode.tabBarLikesNormalImageName,
            selectedImageName: currentColorMode.tabBarLikesSelectedImageName
        )
        
        let bucketsViewController =
            UINavigationController(rootViewController: BucketsCollectionViewController())
        bucketsViewController.tabBarItem = tabBarItemWithTitle(
            NSLocalizedString("CenterButtonTabBar.Buckets", comment: "Main view, bottom bar"),
            normalImageName: currentColorMode.tabBarBucketsNormalImageName,
            selectedImageName: currentColorMode.tabBarBucketsSelectedImageName
        )
        
        let followeesViewController = UINavigationController(
            rootViewController: FolloweesCollectionViewController(
                oneColumnLayoutCellHeightToWidthRatio:
                LargeUserCollectionViewCell.heightToWidthRatio,
                twoColumnsLayoutCellHeightToWidthRatio:
                SmallUserCollectionViewCell.heightToWidthRatio
            )
        )
        
        followeesViewController.tabBarItem = tabBarItemWithTitle(
            NSLocalizedString("CenterButtonTabBar.Following", comment: "Main view, bottom bar"),
            normalImageName: currentColorMode.tabBarFollowingNormalImageName,
            selectedImageName: currentColorMode.tabBarFollowingSelectedImageName
        )
        
        let settingsViewController =
            UINavigationController(rootViewController: self.settingsViewController)
        settingsViewController.tabBarItem = tabBarItemWithTitle(
            NSLocalizedString("CenterButtonTabBar.Settings", comment: "Main view, bottom bar"),
            normalImageName: currentColorMode.tabBarSettingsNormalImageName,
            selectedImageName: currentColorMode.tabBarSettingsSelectedImageName
        )

        viewControllers = [
            likesViewController,
            bucketsViewController,
            shotsCollectionViewController,
            followeesViewController,
            settingsViewController
        ]
        selectedViewController = shotsCollectionViewController
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.shadowColor = UIColor(white: 0, alpha: 0.03).CGColor
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowOpacity = 0.6

        do { // these two lines hide top border line of tabBar - can't be separated
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }

        tabBar.translucent = false
        centerButton.configureForAutoLayout()
        
        let currentColorMode = ColorModeProvider.current()
        centerButton.setImage(UIImage(named: currentColorMode.tabBarCenterButtonNormalImageName), forState: .Normal)
        centerButton.setImage(UIImage(named: currentColorMode.tabBarCenterButtonSelectedImageName), forState: .Selected)
        centerButton.backgroundColor = UIColor.whiteColor()
        centerButton.layer.zPosition = 1
        centerButton.addTarget(
            self,
            action: #selector(didTapCenterButton(_:)),
            forControlEvents: .TouchUpInside
        )
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
        if selectedViewController == shotsCollectionViewController {
            centerButton.selected = true
        }
        prepareAnimatableTabBarItems()
    }

// MARK: - Public
    /// Do any additional configuration in situation
    /// where app was launched with 3D Touch shortcut.
    func configureForLaunchingWithForceTouchShortcut() {
        tabBar.alpha = 1.0
        tabBar.userInteractionEnabled = true
    }

    func animateTabBarItem(item: CenterButtonViewControllers) {
        guard item == .Likes || item == .Buckets else { return }

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic

        let itemToAnimate = item == .Likes ? animatableLikesTabBarItem : animatableBucketsTabBarItem

        itemToAnimate?.layer.addAnimation(bounceAnimation, forKey: nil)

        if let iconImage = itemToAnimate?.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysOriginal)
            itemToAnimate?.image = renderImage
            itemToAnimate?.tintColor = .blackColor()
        }
    }

//    MARK: - Actions

    func didTapCenterButton(_: UIButton) {
        centerButton.selected = true
        selectedViewController = shotsCollectionViewController
    }
}

extension CenterButtonTabBarController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController,
                          didSelectViewController viewController: UIViewController) {
        if selectedIndex != CenterButtonViewControllers.Shots.rawValue {
            centerButton.selected = false
        }
    }
}

private extension CenterButtonTabBarController {

    func tabBarItemWithTitle(title: String, normalImageName: String, selectedImageName:String) -> UITabBarItem {
        
        let image = UIImage(named: normalImageName)?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)?.imageWithRenderingMode(.AlwaysOriginal)

        let tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
        tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName: ColorModeProvider.current().tabBarSelectedItemTextColor],
            forState: .Selected
        )
        tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName: ColorModeProvider.current().tabBarNormalItemTextColor],
            forState: .Normal
        )
        return tabBarItem
    }

    func prepareAnimatableTabBarItems() {
        guard animatableLikesTabBarItem == nil else { return }

        animatableLikesTabBarItem = tabBar.subviews[CenterButtonViewControllers.Likes.rawValue].subviews.first as? UIImageView
        animatableBucketsTabBarItem = tabBar.subviews[CenterButtonViewControllers.Buckets.rawValue].subviews.first as? UIImageView
        animatableLikesTabBarItem?.contentMode = .Center
    }
}
