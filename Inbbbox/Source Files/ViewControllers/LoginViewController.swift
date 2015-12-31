//
//  LoginViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewController: UIViewController {
    
    private var shotsAnimator: AutoScrollableShotsAnimator!
    private weak var aView: LoginView?
    private var onceTokenForScrollToMiddleInstantly = dispatch_once_t(0)
    
    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bindForAnimation = aView?.shotsView.collectionViews.map {
            (collectionView: $0, shots: ShotsStorage().shotsFromAssetCatalog.shuffle())
        } ?? []

        shotsAnimator = AutoScrollableShotsAnimator(bindForAnimation: bindForAnimation)
        aView?.loginButton.addTarget(self, action: "loginButtonDidTap:", forControlEvents: .TouchUpInside)
        aView?.loginAsGuestButton.addTarget(self, action: "loginAsGuestButtonDidTap:", forControlEvents: .TouchUpInside)
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    deinit {
        shotsAnimator.stopAnimation()
    }
    
    //MARK: Actions
    
    func loginButtonDidTap(_: UIButton) {
        
        let interactionHandler: (UIViewController -> Void) = { controller in
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let authenticator = Authenticator(interactionHandler: interactionHandler)
        
        firstly {
            authenticator.loginWithService(.Dribbble)
        }.then { user in
            //NGRTodo: Handle success
            print(user)
        }.error { error in
            //NGRTodo: Handle error
            print(error)
        }
    }
    
    func loginAsGuestButtonDidTap(_: UIButton) {
        //NGRTodo: Move to next screen
    }
}
