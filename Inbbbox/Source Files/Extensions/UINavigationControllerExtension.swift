//
//  UINavigationControllerExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UINavigationController {

    /// Progress view embeding in navigation bar
    ///
    /// - returns: instance of UIProgressView
    func progressViewByEmbedingInNavigationBar() -> UIProgressView {

        let progressView = UIProgressView(progressViewStyle: .Bar)
        navigationBar.addSubview(progressView)

        let bottomConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Bottom, relatedBy: .Equal, toItem: progressView, attribute: .Bottom, multiplier: 1, constant: 1)
        let leftConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Leading, relatedBy: .Equal, toItem: progressView, attribute: .Leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Trailing, relatedBy: .Equal, toItem: progressView, attribute: .Trailing, multiplier: 1, constant: 0)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([bottomConstraint, leftConstraint, rightConstraint])

        return progressView
    }
}
