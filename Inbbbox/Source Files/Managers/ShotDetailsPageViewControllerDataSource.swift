//
//  ShotDetailsPageViewControllerDataSource.swift
//  Inbbbox
//
//  Created by Robert Abramczyk on 26/10/2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

class ShotDetailsPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    // MARK: Properties
    
    var shots = [ShotType]()
    var initialViewController: UIViewController?
    private var shotDetailsViewControllersDictionary = [Int:ShotDetailsViewController]()
    
    // MARK: 
    
    init(shots: [ShotType], initialViewController: ShotDetailsViewController) {
        self.shots = shots
        self.initialViewController = initialViewController
        
        super.init()
    }
    
    // MARK: Private
    
    func getShotDetailsViewController(atIndexPath indexPath: NSIndexPath) -> UIViewController? {
        
        if let controller = shotDetailsViewControllersDictionary[indexPath.row] { return controller }
        
        let shot = shots[indexPath.row]
        let shotDetailsViewController = ShotDetailsViewController(shot: shot)
        shotDetailsViewController.shotIndex = indexPath.row
        shotDetailsViewControllersDictionary[indexPath.row] = shotDetailsViewController
        
        return shotDetailsViewController
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let currentController = viewController as? ShotDetailsViewController where
            currentController.shotIndex > 0,
            let controller = getShotDetailsViewController(atIndexPath: NSIndexPath(forItem: currentController.shotIndex - 1, inSection: 0)) as? ShotDetailsViewController {
            controller.customizeFor3DTouch(false)
            return controller
        }
        else { return nil }
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let currentController = viewController as? ShotDetailsViewController where
            currentController.shotIndex < shots.count - 1,
            let controller = getShotDetailsViewController(atIndexPath: NSIndexPath(forItem: currentController.shotIndex + 1, inSection: 0)) as? ShotDetailsViewController {
            controller.customizeFor3DTouch(false)
            return controller
        }
        else { return nil }
    }
}
