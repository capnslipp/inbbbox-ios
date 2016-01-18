//
//  LoginViewAnimator.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewAnimator {
    
    private weak var view: LoginView?
    private var shouldStopAnimation = true
    private let animations = LoginViewAnimations()
    
    init(view: LoginView?) {
        self.view = view
    }
    
    func startLoginAnimation() {

        guard let view = view where !view.isAnimating else { return }
        
        firstly {
            prepareCanvas()
        }.then {
            self.shrinkToBallWithRotation()
        }.then {
            when(self.ballBounce(), self.loadingFadeIn())
        }.then {
            self.loadingBlink()
        }
    }
    
    func stopAnimation() {
        shouldStopAnimation = true
    }
}

// MARK: Promises
private extension LoginViewAnimator {
    
    func prepareCanvas() -> Promise<Void> {
        
        shouldStopAnimation = false
        view!.isAnimating = true
        view!.loginButton.setTitle(nil, forState: .Normal)
        
        return Promise()
    }
    
    func ballBounce() -> Promise<Void> {
        LoginViewAnimations.bounceAnimation([view!.loginButton, view!.dribbbleLogoImageView], duration: 1, stop: &shouldStopAnimation)
        return Promise()
    }
    
    func loadingFadeIn() -> Promise<Void> {
        return Promise<Void> { fulfill, _ in
            LoginViewAnimations.moveAnimation([view!.loadingLabel], duration: 0.4, fade: .FadeIn, transition: CGPointZero) {
                fulfill()
            }
        }
    }
    
    func loadingBlink() -> Promise<Void> {
        LoginViewAnimations.blinkAnimation([view!.loadingLabel], duration: 1, stop: &shouldStopAnimation)
        return Promise()
    }
    
    func shrinkToBallWithRotation() -> Promise<Void> {
        return Promise<Void> { fulfill, _ in
            
            // logo rotation animation:
            LoginViewAnimations.rotationAnimation([view!.dribbbleLogoImageView], duration: 0.8, cycles: 5)
            
            // fade out button + label animation:
            LoginViewAnimations.moveAnimation([view!.orLabel, view!.loginAsGuestButton], duration: 0.8, fade: .FadeOut, transition: CGPoint(x: 0, y: 200))
            
            // login button corner radius animation
            LoginViewAnimations.animateCornerRadiusForthAndBack(view!.loginButton)
            
            // spring animation uibutton and logo
            LoginViewAnimations.animateSpringShrinkingToBall(view!.loginButton, logo: view!.dribbbleLogoImageView) {
                fulfill()
            }
        }
    }
}
