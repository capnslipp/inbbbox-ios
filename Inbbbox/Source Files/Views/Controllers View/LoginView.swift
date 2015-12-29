//
//  LoginView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let loginButton = UIButton(type: .System)
    let shotsView = AutoScrollableShotsView(numberOfColumns: 4)
    private let pinkOverlayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(shotsView)
        
        pinkOverlayView.backgroundColor = UIColor.pinkColor(alpha: 0.8)
        addSubview(pinkOverlayView)
        
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)
        loginButton.backgroundColor = UIColor.redColor()
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addSubview(loginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shotsView.frame = bounds
        pinkOverlayView.frame = bounds
        loginButton.frame = CGRect(x: CGRectGetMidX(bounds) - 100, y: CGRectGetMaxY(bounds) - 100, width: 200, height: 44)
    }
}
