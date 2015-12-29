//
//  LoginView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

class LoginView: UIView {
    
    private let cornerRadius = CGFloat(28)
    
    let loginButton = UIButton(type: .System)
    let loginAsGuestButton = UIButton(type: .System)
    let shotsView = AutoScrollableShotsView(numberOfColumns: 4)
    let dribbbleLogoImageView = UIImageView(image: UIImage(named: "ic-ball"))
    
    private let logoImageView = UIImageView(image: UIImage(named: "logo-inbbbox"))
    private let pinkOverlayView = UIImageView(image: UIImage(named: "bg-intro-gradient"))
    private let sloganLabel = UILabel()
    private let orLabel = ORLoginLabel()
    private var didSetConstraints = false
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            shotsView.autoPinEdgesToSuperviewEdges()
            pinkOverlayView.autoPinEdgesToSuperviewEdges()
            
            sloganLabel.autoPinEdgeToSuperviewEdge(.Left)
            sloganLabel.autoPinEdgeToSuperviewEdge(.Right)
            sloganLabel.autoCenterInSuperview()
            sloganLabel.autoSetDimension(.Height, toSize: 40)
            
            logoImageView.autoSetDimensionsToSize(logoImageView.image?.size ?? CGSizeZero)
            logoImageView.autoAlignAxisToSuperviewAxis(.Vertical)
            logoImageView.autoPinEdge(.Bottom, toEdge: .Top, ofView: sloganLabel, withOffset: -30)
            
            loginAsGuestButton.autoSetDimension(.Height, toSize: 2 * cornerRadius)
            loginAsGuestButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
            loginAsGuestButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 30)
            loginAsGuestButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 40)
            
            orLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            orLabel.autoSetDimensionsToSize(CGSize(width: 150, height: 60))
            orLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: loginAsGuestButton)
            
            loginButton.autoSetDimension(.Height, toSize: 2 * cornerRadius)
            loginButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
            loginButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 30)
            loginButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: orLabel)
            
            dribbbleLogoImageView.autoSetDimensionsToSize(dribbbleLogoImageView.image?.size ?? CGSizeZero)
            dribbbleLogoImageView.autoAlignAxis(.Horizontal, toSameAxisOfView: loginButton)
            dribbbleLogoImageView.autoPinEdge(.Left, toEdge: .Left, ofView: loginButton, withOffset: 20)
        }
        
        super.updateConstraints()
    }
}
