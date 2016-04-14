//
//  UIViewControllerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Loads view with type of UIView
    ///
    /// - parameter viewType: type of UIView to be loaded


    func loadViewWithClass<T: UIView>(viewType: T.Type) -> T {

        view = T(frame: UIScreen.mainScreen().bounds)
        view.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        return (view as? T)!
    }
}
