//
//  LoginViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices

class LoginViewController: UIViewController {

    var centerButtonTabBarController: CenterButtonTabBarController

    private var shotsAnimator: AutoScrollableShotsAnimator!
    private weak var aView: LoginView?
    private var viewAnimator: LoginViewAnimator?
    private var authenticator: Authenticator?
    private var onceTokenForScrollToMiddleInstantly = dispatch_once_t(0)
    private var logoTappedCount = 0
    private var statusBarStyle: UIStatusBarStyle = .LightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    init(tabBarController: CenterButtonTabBarController) {
        centerButtonTabBarController = tabBarController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message="Use init(tabBarController:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
        viewAnimator = LoginViewAnimator(view: aView, delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bindForAnimation = aView?.shotsView.collectionViews.map {
            (collectionView: $0, shots: ShotsStorage().shotsFromAssetCatalog.shuffle())
        } ?? []

        shotsAnimator = AutoScrollableShotsAnimator(bindForAnimation: bindForAnimation)

aView?.loginButton.addTarget(self, action: #selector(loginButtonDidTap_safari(_:)), forControlEvents: .TouchUpInside)

        aView?.loginAsGuestButton.addTarget(self,
                                            action: #selector(loginAsGuestButtonDidTap(_:)),
                                            forControlEvents: .TouchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped(_:)))
        aView?.logoImageView.addGestureRecognizer(tapGesture)
        aView?.logoImageView.userInteractionEnabled = true
        aView?.loadingLabel.alpha = 0
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        dispatch_once(&onceTokenForScrollToMiddleInstantly) {
            self.shotsAnimator.scrollToMiddleInstantly()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shotsAnimator.startScrollAnimationInfinitely()
        AnalyticsManager.trackScreen(.LoginView)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }

    deinit {
        shotsAnimator?.stopAnimation()
    }
}

// MARK: Actions

extension LoginViewController {

    func loginButtonDidTap_safari(_: UIButton) {

        viewAnimator?.startLoginAnimation()

        let interactionHandler: (SFSafariViewController -> Void) = { controller in
//            after(0.6).then { result -> Void in
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: nil)
//            }
        }

        let success: (Void -> Void) = {
            self.dismissViewControllerAnimated(true) {
                self.viewAnimator?.stopAnimationWithType(.Continue) {
                    self.aView?.loadingLabel.alpha = 0
                    self.aView?.copyrightlabel.alpha = 0
                    self.presentNextViewController()
                }
            }
        }

        let failure: (ErrorType -> Void) = { error in
            self.viewAnimator?.stopAnimationWithType(.Undo)
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        authenticator = Authenticator(interactionHandler: interactionHandler, success: success, failure: failure)
        authenticator?.loginSafariWithService(.Dribbble, trySilent: false)
    }

    func loginButtonDidTap(_: UIButton) {

        viewAnimator?.startLoginAnimation()

        let interactionHandler: (UIViewController -> Void) = { controller in
            after(0.6).then {
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }

        let authenticator = Authenticator(interactionHandler: interactionHandler, success: {
            }, failure: { error in
        })
    }

    func loginAsGuestButtonDidTap(_: UIButton) {
        Authenticator.logout()
        AnalyticsManager.trackLoginEvent(AnalyticsLoginEvent.LoginAsGuest)
        viewAnimator?.startLoginAnimation(stopAfterShrink: true)
    }

    func logoTapped(sender: UITapGestureRecognizer) {
        logoTappedCount += 1
        if logoTappedCount == 5 {
            viewAnimator?.showLoginAsGuest()
            sender.enabled = false
        }
    }
}

extension LoginViewController: LoginViewAnimatorDelegate {

    func tabBarWillAppear() {
        statusBarStyle = .Default
    }

    func shrinkAnimationDidFinish() {
        self.viewAnimator?.stopAnimationWithType(.Continue) {
            self.presentNextViewController()
        }
    }
}

extension LoginViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)

        after(0.5).then { result -> Void in
            // TODO (PIKOR): Why this line is not called, when inside completion of dismissVC?
            self.aView?.loadingLabel.alpha = 0
            self.viewAnimator?.stopAnimationWithType(.Undo)
        }
    }
}

private extension LoginViewController {

    func presentNextViewController() {
        self.presentViewController(centerButtonTabBarController, animated: false, completion: nil)
    }
}
