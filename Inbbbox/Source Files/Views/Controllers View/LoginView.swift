//
//  LoginView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    private let cornerRadius = CGFloat(28)
    
    let loginButton = UIButton(type: .System)
    let loginAsGuestButton = UIButton(type: .System)
    let shotsView = AutoScrollableShotsView(numberOfColumns: 4)
    let dribbbleLogoImageView = UIImageView(image: UIImage(named: "ic-ball"))
    let orLabel = ORLoginLabel()
    let loadingLabel = UILabel()
    
    let logoImageView = UIImageView(image: UIImage(named: "logo-inbbbox"))
    let pinkOverlayView = UIImageView(image: UIImage(named: "bg-intro-gradient"))
    let sloganLabel = UILabel()

    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(shotsView)
        addSubview(pinkOverlayView)
        addSubview(logoImageView)
        addSubview(orLabel)
        addSubview(dribbbleLogoImageView)
        
        loginButton.setTitle(NSLocalizedString("Login with Dribbble", comment: ""), forState: .Normal)
        loginButton.backgroundColor = UIColor.whiteColor()
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.setTitleColor(UIColor.pinkColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont.helveticaFont(.NeueMedium, size: 14)
        insertSubview(loginButton, belowSubview: dribbbleLogoImageView)
        
        loginAsGuestButton.setTitle(NSLocalizedString("Use as guest", comment: ""), forState: .Normal)
        loginAsGuestButton.backgroundColor = UIColor.clearColor()
        loginAsGuestButton.layer.cornerRadius = cornerRadius
        loginAsGuestButton.layer.borderWidth = 1
        loginAsGuestButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginAsGuestButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont.helveticaFont(.NeueMedium, size: 14)
        addSubview(loginAsGuestButton)
        
        sloganLabel.text = NSLocalizedString("Each shot swipes", comment: "")
        sloganLabel.textAlignment = .Center
        sloganLabel.textColor = UIColor.RGBA(249, 212, 226, 1)
        sloganLabel.font = UIFont.helveticaFont(.NeueLight, size: 22)
        addSubview(sloganLabel)
        
        loadingLabel.text = NSLocalizedString("LOADING...", comment: "")
        loadingLabel.textAlignment = .Center
        loadingLabel.textColor = UIColor.RGBA(249, 212, 226, 1)
        loadingLabel.font = UIFont.helveticaFont(.Neue, size: 12)
        addSubview(loadingLabel)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        /**
            Sorry for using rects here, but autolayout is going crazy with
            animations provided by our designer...
        
            If you want to be devoured by UIKit mutable state, please refactor this to autolayout.
        */
        if !isAnimating {
            
            let inset = CGFloat(30)
            let height = 2 * cornerRadius
            loginButton.frame = CGRect(
                x: inset,
                y: CGRectGetMinY(orLabel.frame) - height,
                width: CGRectGetWidth(frame) - 2 * inset,
                height: height
            )
            
            let size = dribbbleLogoImageView.image?.size ?? CGSizeZero
            dribbbleLogoImageView.frame = CGRect(
                x: CGRectGetMinX(loginButton.frame) + 30,
                y: CGRectGetMidY(loginButton.frame) - size.height * 0.5,
                width: size.width,
                height: size.height
            )
            
            loginAsGuestButton.frame = CGRect(
                x: inset,
                y: CGRectGetMaxY(frame) - 40 - height,
                width: CGRectGetWidth(frame) - 2 * inset,
                height: height
            )
            
            let width = CGFloat(150)
            orLabel.frame = CGRect(
                x: CGRectGetMidX(frame) - width * 0.5,
                y: CGRectGetMinY(loginAsGuestButton.frame) - height,
                width: width,
                height: 60
            )
            
            loadingLabel.frame = CGRect(
                x: 0,
                y: CGRectGetMaxY(frame) - 50,
                width: CGRectGetWidth(frame),
                height: 20
            )
            
            let sloganHeight = CGFloat(40)
            sloganLabel.frame = CGRect(
                x: 0,
                y: CGRectGetMidY(frame) - sloganHeight * 0.5,
                width: CGRectGetWidth(frame),
                height: sloganHeight
            )
            
            let imageSize = logoImageView.image!.size ?? CGSizeZero
            logoImageView.frame = CGRect(
                x: CGRectGetMidX(frame) - imageSize.width * 0.5,
                y: CGRectGetMinY(sloganLabel.frame) - 30 - imageSize.height,
                width: imageSize.width,
                height: imageSize.height
            )
            
            shotsView.frame = frame
            pinkOverlayView.frame = frame
        }
    }
}
