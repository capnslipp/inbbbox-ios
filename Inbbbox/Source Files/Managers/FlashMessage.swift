//
//  FlashMessage.swift
//  Inbbbox
//
//  Created by Blazej Wdowikowski on 11/2/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class FlashMessage: NSObject {
    
    static let sharedInstance = FlashMessage()
    
    /// Set a custom offset for the notification view
    var offsetHeightForMessage: CGFloat = 0.0
    
    var customizeMessageView: ((FlashMessageView) -> Void)?
    
    /// Use this property to set a default view controller to display the messages in
    var defaultViewController: UIViewController  {
        get {
            return _defaultViewController ?? UIApplication.sharedApplication().keyWindow!.rootViewController!
        }
        set {
            _defaultViewController = newValue
        }
    }
    
    private let DisplayTime = 1.5
    private let ExtraDisplayTimePerPixel = 0.04
    private let AnimationDuration = 0.3
    
    /// Indicates whether a notification is currently active.
    private(set) var notificationActive = false
    
    private var messages = [FlashMessageView]()
    private weak var _defaultViewController :UIViewController?
    
    override init() {
        super.init()
    }
    
    /// Shows a notification message in a specific view controller
    ///
    /// - parameter viewController:     The view controller to show the notification in.
    /// - parameter title:              The title of the notification view
    /// - parameter duration:           The duration of the notification being displayed  (Automatic, Endless, Custom)
    /// - parameter messagePosition:    The position of the message on the screen
    /// - parameter overrideStyle:      Override default styles using this style struct, it has highest priority.
    /// - parameter dismissingEnabled:  Should the message be dismissed when the user taps/swipes it
    /// - parameter callback:           The block that should be executed, when the user tapped on the message/
    func showNotification(inViewController viewController: UIViewController? = nil,
                                           title: String,
                                           duration: FlashMessageDuration = .Automatic,
                                           atPosition messagePosition: FlashMessageNotificationPosition = .Top,
                                                      overrideStyle: FlashMessageView.Style? = nil,
                                                      canBeDismissedByUser dismissingEnabled: Bool = true,
                                                                           callback: (() -> Void)? = nil) {
        
        let messageView  = FlashMessageView(
            viewController: viewController ?? defaultViewController,
            title: title,
            duration: duration,
            position: messagePosition,
            style: overrideStyle,
            dismissingEnabled: dismissingEnabled,
            callback: callback)
        
        messageView.fadeOut = { [weak messageView, weak self] in
            if let messageView = messageView {
                self?.fadeOutNotification(messageView)
            }
        }
        
        messages.append(messageView)
        
        
        if !notificationActive {
            fadeInCurrentNotification()
        }
    }
    
    /**
     
     Fades out the currently displayed notification. If another notification is in the queue,
     the next one will be displayed automatically
     
     - Returns: true if the currently displayed notification was successfully dismissed. NO if no notification
     was currently displayed.
     */
    func dismissActiveNotification() -> Bool {
        return dismissActiveNotificationWithCompletion(nil)
    }
    
    
    func dismissActiveNotificationWithCompletion(completion: (() -> Void)?) -> Bool {
        if messages.count == 0 {
            return false
        }
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            if self.messages.count == 0 {
                return
            }
            let currentMessage = self.messages[0]
            if currentMessage.messageIsFullyDisplayed {
                self.fadeOutNotification(currentMessage, animationFinishedBlock: completion)
            } else {
                
                NSTimer.scheduledTimerWithTimeInterval(self.AnimationDuration + 0.1, target: NSBlockOperation(block: {
                    self.fadeOutNotification(currentMessage, animationFinishedBlock: completion)
                }), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
                
            }
        })
        return true
    }
    
    ///  The currently queued array of FlashMessageView
    var  queuedMessages: [FlashMessageView] {
        return messages
    }
    
    private func fadeInCurrentNotification() {
        if messages.count == 0 {
            return
        }
        notificationActive = true
        let currentView = messages[0]
        var verticalOffset: CGFloat = 0.0
        let addStatusBarHeightToVerticalOffset = {() -> Void in
            if currentView.messagePosition == .NavBarOverlay {
                return
            }
            let statusBarSize: CGSize = UIApplication.sharedApplication().statusBarFrame.size
            verticalOffset += min(statusBarSize.width, statusBarSize.height)
        }
        if (currentView.viewController is  UINavigationController) || (currentView.viewController.parentViewController is UINavigationController) {
            let currentNavigationController = currentView.viewController as? UINavigationController ?? currentView.viewController.parentViewController as! UINavigationController
            var isViewIsUnderStatusBar: Bool = (currentNavigationController.childViewControllers[0].edgesForExtendedLayout == .All)
            if !isViewIsUnderStatusBar && currentNavigationController.parentViewController == nil {
                isViewIsUnderStatusBar = !FlashMessage.isNavigationBarInNavigationControllerHidden(currentNavigationController)
            }
            if !FlashMessage.isNavigationBarInNavigationControllerHidden(currentNavigationController) && currentView.messagePosition != .NavBarOverlay {
                currentNavigationController.view!.insertSubview(currentView, belowSubview: currentNavigationController.navigationBar)
                verticalOffset = currentNavigationController.navigationBar.bounds.size.height
                if isViewIsUnderStatusBar {
                    addStatusBarHeightToVerticalOffset()
                }
            }
            else {
                currentView.viewController.view!.addSubview(currentView)
                if isViewIsUnderStatusBar {
                    addStatusBarHeightToVerticalOffset()
                }
            }
        }
        else {
            currentView.viewController.view!.addSubview(currentView)
            addStatusBarHeightToVerticalOffset()
        }
        var toPoint: CGPoint
        if currentView.messagePosition != .Bottom {
            toPoint = CGPointMake(currentView.center.x, offsetHeightForMessage + verticalOffset + CGRectGetHeight(currentView.frame) / 2.0)
        }
        else {
            var y: CGFloat = currentView.viewController.view.bounds.size.height - CGRectGetHeight(currentView.frame) / 2.0
            if let toolbarHidden = currentView.viewController.navigationController?.toolbarHidden where !toolbarHidden {
                y -= CGRectGetHeight(currentView.viewController.navigationController!.toolbar.bounds)
            }
            toPoint = CGPointMake(currentView.center.x, y)
        }
        
        customizeMessageView?(currentView)
        
        let animationBlock = {
            currentView.center = toPoint
        }
        let completionBlock = {(finished :Bool)  in
            currentView.messageIsFullyDisplayed = true
        }
        
        UIView.animateWithDuration(self.AnimationDuration + 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.CurveEaseInOut, .BeginFromCurrentState, .AllowUserInteraction], animations: animationBlock, completion: completionBlock)
        
        var durationToPresent: NSTimeInterval?
        switch(currentView.duration) {
        case .Automatic:
            durationToPresent = AnimationDuration + DisplayTime + NSTimeInterval(currentView.frame.size.height) * ExtraDisplayTimePerPixel
        case .Custom(let timeInterval):
            durationToPresent = timeInterval
        default:
            break
        }
        
        if let durationToPresent = durationToPresent {
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.performSelector(#selector(FlashMessage.fadeOutNotification(_:)), withObject: currentView, afterDelay: durationToPresent)
            })
        }
    }
    
    class func isNavigationBarInNavigationControllerHidden(navController: UINavigationController) -> Bool {
        if navController.navigationBarHidden {
            return true
        }
        else if navController.navigationBar.hidden {
            return true
        }
        else {
            return false
        }
    }
    
    func fadeOutNotification(currentView: FlashMessageView) {
        fadeOutNotification(currentView, animationFinishedBlock: nil)
    }
    
    func fadeOutNotification(currentView: FlashMessageView, animationFinishedBlock animationFinished: (() -> Void)?) {
        currentView.messageIsFullyDisplayed = false
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(FlashMessage.fadeOutNotification(_:)), object: currentView)
        var fadeOutToPoint: CGPoint
        if currentView.messagePosition != .Bottom {
            fadeOutToPoint = CGPointMake(currentView.center.x, -CGRectGetHeight(currentView.frame) / 2.0)
        }
        else {
            fadeOutToPoint = CGPointMake(currentView.center.x, currentView.viewController.view.bounds.size.height + CGRectGetHeight(currentView.frame) / 2.0)
        }
        UIView.animateWithDuration(AnimationDuration, animations: {() -> Void in
            currentView.center = fadeOutToPoint
            }, completion: {(finished: Bool) -> Void in
                currentView.removeFromSuperview()
                if self.messages.count > 0 {
                    self.messages.removeAtIndex(0)
                }
                self.notificationActive = false
                if self.messages.count > 0 {
                    self.fadeInCurrentNotification()
                }
                if finished {
                    animationFinished?()
                }
        })
    }
}
