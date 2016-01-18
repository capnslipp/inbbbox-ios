//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class InitialShotsPresentationStep: PresentationStep, PresentationStepViewControllerDelegate {

//    MARK: - PresentationStep

    weak var presentationStepDelegate: PresentationStepDelegate?

    var presentationStepViewController: PresentationStepViewController {

//        NGRTemp: temporary implementation

        let tabBarController = CenterButtonTabBarController()
        let likesViewController = UIViewController()
        likesViewController.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(named: "ic-likes"), selectedImage: UIImage(named: "ic-likes-active"))
        let bucketsViewController = UIViewController()
        bucketsViewController.tabBarItem = UITabBarItem(title: "Buckets", image: UIImage(named: "ic-buckets"), selectedImage: UIImage(named: "ic-buckets-active"))
        let shotsViewController = InitialShotsCollectionViewController()
        let followingViewController = UIViewController()
        followingViewController.tabBarItem = UITabBarItem(title: "Following", image: UIImage(named: "ic-following"), selectedImage: UIImage(named: "ic-following-active"))
        let accountViewController = UIViewController()
        accountViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "ic-account"), selectedImage: UIImage(named: "ic-account-active"))
        tabBarController.viewControllers = [likesViewController, bucketsViewController, shotsViewController, followingViewController, accountViewController]
        tabBarController.selectedViewController = shotsViewController

        let presentationStepViewController = shotsViewController
        presentationStepViewController.presentationStepViewControllerDelegate = self
        return presentationStepViewController
    }

//    MARK: - PresentationStepViewControllerDelegate

    func presentationStepViewControllerDidFinishPresenting(presentationStepViewController: PresentationStepViewController) {
        presentationStepDelegate?.presentationStepDidFinish(self)
    }
}
