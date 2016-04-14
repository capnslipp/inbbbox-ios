//
//  UITableViewExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UITableView {

    /// Deselects row if is already selected
    ///
    /// -parameter animated: bool value that indicates if deselection should be animated


    func deselectRowIfSelectedAnimated(animated: Bool) {
        if let indexPath = indexPathForSelectedRow {
            deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }

    /// Reloads and deselects row at index path.
    ///
    /// -parameter indexPath: index path of row
    /// -parameter animated: bool value that indicates if deselection should be animated. Default is true.


    func reloadAndDeselectRowAtIndexPath(indexPath: NSIndexPath, animated: Bool = true) {
        reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        deselectRowAtIndexPath(indexPath, animated: animated)
    }

    /// Hides separator for empty cells
    func hideSeparatorForEmptyCells() {
        tableFooterView = UIView(frame: CGRect.zero)
    }

    /// Registers class
    ///
    /// - parameter aClass: type of UITableViewCell which conforms to Reusable protocol
    func registerClass<T: UITableViewCell where T: Reusable>(aClass: T.Type) {
        registerClass(aClass, forCellReuseIdentifier: T.reuseIdentifier)
    }

    /// Dequeues reusable cell
    ///
    /// - parameter aClass: type of UITableViewCell which conforms to Reusable protocol
    ///
    /// - returns: reusable cell with proper reuse identifier. Used to acquire an already allocated cell, in lieu of allocating a new one.
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(aClass: T.Type) -> T {
        return (dequeueReusableCellWithIdentifier(T.reuseIdentifier) as? T)!
    }
}
