//
//  MFMailComposeViewControllerExtension.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 20.04.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import MessageUI

extension MFMailComposeViewController {
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}
