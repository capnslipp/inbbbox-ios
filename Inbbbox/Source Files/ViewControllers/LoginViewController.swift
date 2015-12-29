//
//  LoginViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

// NGRTemp: temporary implementation
class LoginViewController: UIViewController {
    
    private var shotsAnimator: AutoScrollableShotsAnimator!
    private weak var aView: LoginView?
    
    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shotsAnimator = AutoScrollableShotsAnimator(collectionViewsToAnimate: aView?.shotsView.colectionViews ?? [])
        aView?.loginButton.addTarget(self, action: "loginButtonDidTap:", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        firstly {
            after(1)
        }.then {
            self.shotsAnimator.scrollToMiddleInstantly()
        }.then {
            self.shotsAnimator.startScrollAnimationIndefinitely()
        }
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
}
