//
//  LoginViewController.swift
//  Tindddler
//
//  Created by Patryk Kaczmarek on 16/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

// NGRTemp: temporary implementation
class LoginViewController: UIViewController {
    
    private let loginButton = UIButton(type: .System)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor();
        
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)
        loginButton.addTarget(self, action: "loginButtonDidTap:", forControlEvents: .TouchUpInside)
        loginButton.backgroundColor = .redColor()
        loginButton.setTitleColor(.whiteColor(), forState: .Normal)

        view.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inset: CGFloat = 20.0;
        loginButton.frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds) - 2 * inset, 44)
        loginButton.center = view.center
    }
    
    //MARK: Actions
    
    func loginButtonDidTap(_: UIButton) {
        // intentionally blank
    }
}
