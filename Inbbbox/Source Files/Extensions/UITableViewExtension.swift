//
//  UITableViewExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UITableView {
    
    func deselectRowIfSelectedAnimated(animated: Bool) {
        if let indexPath = self.indexPathForSelectedRow {
            deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    func reloadAndDeselectRowAtIndexPath(indexPath: NSIndexPath, animated: Bool = true)  {
        reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        deselectRowAtIndexPath(indexPath, animated: animated)
    }
    
    func hideSeparatorForEmptyCells() {
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerClass<T: UITableViewCell where T: Reusable>(aClass: T.Type) {
        registerClass(aClass, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(aClass: T.Type) -> T {
        return dequeueReusableCellWithIdentifier(T.reuseIdentifier) as! T
    }
}
