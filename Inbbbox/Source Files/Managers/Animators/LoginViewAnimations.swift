//
//  LoginViewAnimations.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import EasyAnimation
import Async

class LoginViewAnimations {
    
    private var buttonPositionDelta: (x: CGFloat, width: CGFloat)!
    private var logoPositionDeltaX: CGFloat!
    private var shouldAnimate = false
    
    enum FadeStyle: CGFloat {
        case FadeIn = 1
        case FadeOut = 0
    }
    
    func prepare() {
        shouldAnimate = true
    }
    
    func stop() {
        shouldAnimate = false
    }
    
    func animateCornerRadiusForthAndBack(view: UIView) {
        
        let endValue = CGRectGetHeight(view.frame ?? CGRectZero) * 0.5
        
        UIView.animateAndChainWithDuration(0.2, delay: 0, options: [], animations: {
            view.layer.cornerRadius = 4
        }, completion: nil).animateWithDuration(0.5, animations: {
            view.layer.cornerRadius = endValue
        })
    }
    
    func animateSpringShrinkingToBall(button: UIView, logo: UIView, completion: () -> Void) {
        
        let dimension = CGRectGetHeight(button.frame ?? CGRectZero)
        let deltaX = CGRectGetMidX(button.superview!.bounds) - dimension * 0.5 - CGRectGetMinX(button.frame)
        
        buttonPositionDelta = (x: deltaX, width: CGRectGetWidth(button.frame))
        logoPositionDeltaX = CGRectGetMidX(logo.superview!.bounds) - CGRectGetMidX(logo.frame)
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.0, options: [.FillModeForwards], animations: {
            
            button.layer.position.x += deltaX
            button.layer.frame.size.width = dimension
            logo.layer.position.x += self.logoPositionDeltaX
            
        }, completion: { _ in
            completion()
        })
    }
    
    func animateSpringExtendingToButton(button: UIView, logo: UIView, completion: () -> Void) {
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.0, options: [.FillModeForwards], animations: {
            
            button.layer.position.x -= self.buttonPositionDelta.x
            button.layer.frame.size.width = self.buttonPositionDelta.width
            logo.layer.position.x -= self.logoPositionDeltaX
            
        }, completion: { _ in
            completion()
        })
    }
    
    func rotationAnimation(views: [UIView], duration: NSTimeInterval, cycles: Double) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI * 2.0 * cycles * duration)
        rotationAnimation.duration = duration
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = 1.0;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        views.forEach {
            $0.layer.addAnimation(rotationAnimation, forKey: nil)
        }
    }
    
    func moveAnimation(views: [UIView], duration: NSTimeInterval, fade: FadeStyle, easeFunction:UIViewAnimationOptions = .CurveEaseIn, transition: CGPoint, completion: (() -> Void)? = nil) {
        
        UIView.animateWithDuration(duration, delay: 0, options: [easeFunction], animations: {
            views.forEach {
                let frame = CGRect(
                    x: CGRectGetMinX($0.frame) + transition.x,
                    y: CGRectGetMinY($0.frame) + transition.y,
                    width: CGRectGetWidth($0.frame),
                    height: CGRectGetHeight($0.frame)
                )
                
                $0.frame = frame
                $0.alpha = fade.rawValue
            }
        }, completion: { _ in
            completion?()
        })
    }
    
    func blinkAnimation(views: [UIView], duration: NSTimeInterval) {
        
        if !shouldAnimate {
            return
        }
        
        Async.main(after: duration) {
            self.blinkAnimation(views, duration: duration)
        }
        
        UIView.animateWithDuration(duration * 0.5, animations: {
            views.forEach { $0.alpha = 0.5 }
        }, completion: { _ in
            UIView.animateWithDuration(duration * 0.5) { views.forEach { $0.alpha = 1.0 } }
        })
    }
    
    func bounceAnimation(views: [UIView], duration: NSTimeInterval, additionalYOffset: Bool) {
        
        guard shouldAnimate else { return }
        
        Async.main(after: duration) {
            self.bounceAnimation(views, duration: duration, additionalYOffset: additionalYOffset)
        }
        let maxY = additionalYOffset ? 100 : 70
        
        let animations = CAKeyframeAnimation.ballBounceAnimations(maxY, duration: duration)
        
        views.forEach { view in
            animations.forEach { animation in
                view.layer.addAnimation(animation, forKey: nil)
            }
        }
    }
}
