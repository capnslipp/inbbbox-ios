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
        let alert = UIAlertController(title: NSLocalizedString("New Bucket", comment: ""), message: NSLocalizedString("Provide name for new bucket", comment: ""), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .Default) { _ in
            if let bucketName = alert.textFields?[0].text {
                createHandler(bucketName: bucketName)
            }
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = NSLocalizedString("Enter bucket name:", comment: "")
        })
        
        return alert
    }
    
    class func generalErrorAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: NSLocalizedString("Error occurred", comment: ""),
            message: NSLocalizedString("Try again in a while.", comment: ""),
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Cancel, handler: nil))
        
        return alert
    }

    class func inappropriateContentReportedAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("Inappropriate content has been reported. Verification and blocking will take up to 24 hours.",
                comment: ""),
            preferredStyle: .Alert
        )
        let okActionTitle = NSLocalizedString("OK", comment: "")
        alert.addAction(UIAlertAction(title: okActionTitle, style: .Default, handler: nil))

        return alert
    }
}
