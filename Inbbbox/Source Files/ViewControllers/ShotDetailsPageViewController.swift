//
//  ShotDetailsPageViewController.swift
//  Inbbbox
//
//  Created by Robert Abramczyk on 25/10/2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ZFDragableModalTransition

class ShotDetailsPageViewController: UIPageViewController {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    private var modalTransitionAnimator: ZFModalTransitionAnimator?
    var normalStateHandler: ShotsNormalStateHandler
    private var didSetConstraints = false
    private var firstViewController: UIViewController?
    
    // MARK: Life cycle
    
    @available(*, unavailable, message = "Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(shotsNormalStateHander: ShotsNormalStateHandler, initialViewController: UIViewController) {
        normalStateHandler = shotsNormalStateHander
        firstViewController = initialViewController
        
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
}

// MARK: UIViewController

extension ShotDetailsPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let controller = firstViewController {
            setViewControllers([controller],
                                   direction: .Forward,
                                   animated: true,
                                   completion: nil)
        }
        
        if DeviceInfo.shouldDowngrade() {
            view.backgroundColor = .backgroundGrayColor()
        } else {
            view.backgroundColor = .clearColor()
            blurView.configureForAutoLayout()
            view.addSubview(blurView)
            view.sendSubviewToBack(blurView)
        }
        
        updateConstraints()
    }
    
    func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            if !DeviceInfo.shouldDowngrade() {
                blurView.autoPinEdgesToSuperviewEdges()
            }
        }
    }
}

// MARK: ModalByDraggingClosable

extension ShotDetailsPageViewController: ModalByDraggingClosable {
    var scrollViewToObserve: UIScrollView {
        for v in view.subviews{
            if v.isKindOfClass(UIScrollView){
                return v as! UIScrollView
            }
        }
        return UIScrollView()
    }
}

// MARK: UIPageViewControllerDataSource

extension ShotDetailsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = normalStateHandler.getViewControllerForPreviewing(atIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as? ShotDetailsViewController {
            //controller.hideBlurViewFor3DTouch(false)
            return controller
        }
        else { return nil }
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = normalStateHandler.getViewControllerForPreviewing(atIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as? ShotDetailsViewController {
            //controller.hideBlurViewFor3DTouch(false)
            return controller
        }
        else { return nil }
    }
    
}