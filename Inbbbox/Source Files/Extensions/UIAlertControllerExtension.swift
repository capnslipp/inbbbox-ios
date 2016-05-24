//
//  UIAlertControllerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 09/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AOAlertController

extension UIAlertController {

    // MARK: Shared Settings

    class func setupAlertControllerSharedSettings() {
        AOAlertSettings.sharedSettings.backgroundColor = .backgroundGrayColor()
        AOAlertSettings.sharedSettings.linesColor = .backgroundGrayColor()
        AOAlertSettings.sharedSettings.defaultActionColor = .pinkColor()
        AOAlertSettings.sharedSettings.cancelActionColor = .pinkColor()

        AOAlertSettings.sharedSettings.messageFont = UIFont.helveticaFont(.NeueMedium, size: 17)
        AOAlertSettings.sharedSettings.defaultActionFont = UIFont.helveticaFont(.Neue, size: 16)
        AOAlertSettings.sharedSettings.cancelActionFont = UIFont.helveticaFont(.Neue, size: 16)
        AOAlertSettings.sharedSettings.destructiveActionFont = UIFont.helveticaFont(.Neue, size: 16)

        AOAlertSettings.sharedSettings.blurredBackground = true
    }

    // MARK: Buckets

    class func provideBucketNameAlertController(createHandler: (bucketName: String) -> Void)
                    -> UIAlertController {
        let alertTitle = NSLocalizedString("UIAlertControllerExtension.NewBucket",
                                  comment: "Allows user to create new bucket.")
        let alertMessage = NSLocalizedString("UIAlertControllerExtension.ProvideName",
                                    comment: "Provide name for new bucket")
        let alert = UIAlertController(title: alertTitle,
                                    message: alertMessage,
                             preferredStyle: .Alert)

        let cancelActionTitle = NSLocalizedString("UIAlertControllerExtension.Cancel",
                                         comment: "Cancel creating new bucket.")
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .Cancel, handler: nil))

        let createActionTitle = NSLocalizedString("UIAlertControllerExtension.Create",
                                         comment: "Create new bucket.")
        alert.addAction(UIAlertAction(title: createActionTitle, style: .Default) { _ in
            if let bucketName = alert.textFields?[0].text {
                createHandler(bucketName: bucketName)
            }
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = NSLocalizedString("UIAlertControllerExtension.BucketName",
                                             comment: "Asks user to enter bucket name.")
        })

        return alert
    }

    class func unableToCreateNewBucket() -> AOAlertController {
        let message = NSLocalizedString("BucketsCollectionViewController.NewBucketFail",
                                        comment: "Displayed when creating new bucket fails.")

        return UIAlertController.createAlert(message)
    }

    class func addRemoveShotToBucketFail() -> AOAlertController {
        let message = NSLocalizedString("ShotDetailsViewController.BucketError",
                                        comment: "Error while adding/removing shot to bucket.")

        return UIAlertController.createAlert(message)
    }

    // MARK: Comments

    class func unableToDeleteComment() -> AOAlertController {
        let message = NSLocalizedString("ShotDetailsViewController.RemovingCommentError", comment: "Error while removing comment.")

        return UIAlertController.createAlert(message)
    }

    class func unableToAddComment() -> AOAlertController {
        let message = NSLocalizedString("ShotDetailsViewController.AddingCommentError",
                                        comment: "Error while adding comment.")

        return UIAlertController.createAlert(message)
    }

    // MARK: Downloads

    class func unableToDownloadItemsAlertController() -> AOAlertController {
        let message = NSLocalizedString("UIAlertControllerExtension.UnableToDownload",
                                        comment: "Informing user about problems with downloading items.")

        return UIAlertController.createAlert(message)
    }

    // MARK: Other

    class func generalErrorAlertController() -> AOAlertController {
        let message = NSLocalizedString("UIAlertControllerExtension.TryAgain",
                comment: "Allows user to try again after error occurred.")

        return UIAlertController.createAlert(message)
    }

    class func inappropriateContentReportedAlertController() -> AOAlertController {
        let message = NSLocalizedString("UIAlertControllerExtension.InappropriateContentReported", comment: "nil")

        let okActionTitle = NSLocalizedString("UIAlertControllerExtension.OK", comment: "OK")
        let okAction = AOAlertAction(title: okActionTitle, style: .Default, handler: nil)

        return UIAlertController.createAlert(message, action: okAction)
    }

    class func emailAccountNotFoundAlertController() -> AOAlertController {
        let message = NSLocalizedString("UIAlertControllerExtension.EmailError",
                comment: "Displayed when user device is not capable of/configured to send emails.")

        return UIAlertController.createAlert(message)
    }

    class func signOutAlertController() -> AOAlertController {
        let message = NSLocalizedString("ShotsCollectionViewController.SignOut",
                comment: "Message informing user will be logged out because of an error.")
        let alert = AOAlertController(title: nil, message: message, style: .Alert)

        let dismissActionTitle = NSLocalizedString("ShotsCollectionViewController.Dismiss",
                comment: "Dismiss error alert.")
        let dismissAction = AOAlertAction(title: dismissActionTitle, style: .Default) { _ in
            Authenticator.logout()
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.rollbackToLoginViewController()
            }
        }
        alert.addAction(dismissAction)

        return alert
    }

    // MARK: Private

    private class func defaultDismissAction(style: AOAlertActionStyle = .Default) -> AOAlertAction {
        let title = NSLocalizedString("UIAlertControllerExtension.Dismiss", comment: "Dismiss")
        let action = AOAlertAction(title: title, style: style, handler: nil)

        return action
    }

    private class func createAlert(message: String,
                                   action: AOAlertAction = UIAlertController.defaultDismissAction(),
                                   style: AOAlertControllerStyle = .Alert) -> AOAlertController {
        let alert = AOAlertController(title: nil, message: message, style: style)
        alert.addAction(action)

        return alert
    }
}
