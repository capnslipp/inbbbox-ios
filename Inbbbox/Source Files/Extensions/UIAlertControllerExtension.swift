//
//  UIAlertControllerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 09/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func provideBucketNameAlertController(createHandler: (bucketName: String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("UIAlertControllerExtension.NewBucket", comment: "Allows user to create new bucket."), message: NSLocalizedString("UIAlertControllerExtension.ProvideName", comment: "Provide name for new bucket"), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertControllerExtension.Cancel", comment: "Cancel creating new bucket."), style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertControllerExtension.Create", comment: "Create new bucket."), style: .Default) { _ in
            if let bucketName = alert.textFields?[0].text {
                createHandler(bucketName: bucketName)
            }
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = NSLocalizedString("UIAlertControllerExtension.BucketName", comment: "Asks user to enter bucket name.")
        })

        return alert
    }

    class func generalErrorAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: NSLocalizedString("UIAlertControllerExtension.Error", comment: "General popup informing about error."),
            message: NSLocalizedString("UIAlertControllerExtension.TryAgain", comment: "Allows user to try again after error occurred."),
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertControllerExtension.OK", comment: "OK"), style: .Cancel, handler: nil))

        return alert
    }
}
