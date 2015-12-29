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
    
    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shotsAnimator = AutoScrollableShotsAnimator(collectionViewsToAnimate: aView?.shotsView.collectionViews ?? [])
        aView?.loginButton.addTarget(self, action: "loginButtonDidTap:", forControlEvents: .TouchUpInside)
        aView?.loginAsGuestButton.addTarget(self, action: "loginAsGuestButtonDidTap:", forControlEvents: .TouchUpInside)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) {
            self.shotsAnimator.scrollToMiddleInstantly()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        shotsAnimator.startScrollAnimationIndefinitely()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
