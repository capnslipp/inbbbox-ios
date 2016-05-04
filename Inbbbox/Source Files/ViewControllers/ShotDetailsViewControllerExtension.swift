//
//  ShotDetailsViewControllerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 02/05/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ImageViewer
import MessageUI
import TTTAttributedLabel

// MARK: ImageProvider

extension ShotDetailsViewController: ImageProvider {

    func provideImage(completion: UIImage? -> Void) {
        completion(header?.imageView.image)
    }
}

// MARK: KeyboardResizableViewDelegate

extension ShotDetailsViewController: KeyboardResizableViewDelegate {

    func keyboardResizableView(view: KeyboardResizableView, willRelayoutSubviewsWithState state: KeyboardState) {
        let round = state == .WillAppear
        shotDetailsView.commentComposerView.animateByRoundingCorners(round)
    }
}

// MARK: ModalByDraggingClosable

extension ShotDetailsViewController: ModalByDraggingClosable {
    var scrollViewToObserve: UIScrollView {
        return shotDetailsView.collectionView
    }
}

// MARK: CommentComposerViewDelegate

extension ShotDetailsViewController: CommentComposerViewDelegate {

    func didTapSendButtonInComposerView(view: CommentComposerView, comment: String) {

        view.startAnimation()

        viewModel.postComment(comment).then { () -> Void in

            let indexPath = NSIndexPath(forItem: self.shotDetailsView.collectionView.numberOfItemsInSection(0),
                inSection: 0)
            self.shotDetailsView.collectionView.performBatchUpdates({ () -> Void in
                self.shotDetailsView.collectionView.insertItemsAtIndexPaths([indexPath])
            }, completion: { _ -> Void in
                self.shotDetailsView.collectionView.scrollToItemAtIndexPath(indexPath,
                        atScrollPosition: .CenteredVertically, animated: true)
            })
        }.always {
            view.stopAnimation()
        }.error { error in
            // NGRTemp: Handle error.
        }
    }

    func commentComposerViewDidBecomeActive(view: CommentComposerView) {
        scroller.scrollToBottomAnimated(true)
    }
}

// MARK: UIScrollViewDelegate

extension ShotDetailsViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        animateHeader(start: false)
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        !decelerate ? animateHeader(start: true) : {}()
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        animateHeader(start: true)
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension ShotDetailsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {

        controller.dismissViewControllerAnimated(true) {
            self.hideUnusedCommentEditingViews()
        }

        switch result {
        case MFMailComposeResultSent:
            let contentReportedAlert = UIAlertController.inappropriateContentReportedAlertController()
            presentViewController(contentReportedAlert, animated: true) {
                contentReportedAlert.view.tintColor = .pinkColor()
            }
            contentReportedAlert.view.tintColor = .pinkColor()
        default: break
        }
    }
}

// MARK: TTTAttributedLabelDelegate

extension ShotDetailsViewController: TTTAttributedLabelDelegate {

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        if let user = viewModel.userForURL(url) {
            presentUserDetailsViewControllerForUser(user)
        }
    }
}

// MARK: AvatarViewDelegate

extension ShotDetailsViewController: AvatarViewDelegate {

    func avatarView(avatarView: AvatarView, didTapButton avatarButton: UIButton) {
        var user: UserType?
        if avatarView.superview == header {
            user = viewModel.shot.user
        } else if avatarView.superview?.superview is ShotDetailsCommentCollectionViewCell {

            guard let cell = avatarView.superview?.superview as? ShotDetailsCommentCollectionViewCell else { return }

            if let indexPath = shotDetailsView.collectionView.indexPathForCell(cell) {
                let index = viewModel.indexInCommentArrayBasedOnItemIndex(indexPath.row)
                user = viewModel.comments[index].user
            }
        }
        if let user = user {
            presentUserDetailsViewControllerForUser(user)
        }
    }
}

// MARK: UICollectionViewCellWithLabelContainingClickableLinksDelegate

extension ShotDetailsViewController: UICollectionViewCellWithLabelContainingClickableLinksDelegate {

    func labelContainingClickableLinksDidTap(gestureRecognizer: UITapGestureRecognizer,
                                             textContainer: NSTextContainer, layoutManager: NSLayoutManager) {

        guard let url = UrlDetector.detectUrlFromGestureRecognizer(gestureRecognizer,
                                                                   textContainer: textContainer,
                                                                   layoutManager: layoutManager) else { return }

        if viewModel.shouldOpenUserDetailsFromUrl(url) {
            if let identifier = url.absoluteString.componentsSeparatedByString("/").last {
                viewModel.userForId(identifier).then { [weak self] user in
                    self?.presentUserDetailsViewControllerForUser(user)
                }
            }
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

// MARK: Protocols

protocol UICollectionViewCellWithLabelContainingClickableLinksDelegate: class {

    func labelContainingClickableLinksDidTap(gestureRecognizer: UITapGestureRecognizer,
                                             textContainer: NSTextContainer, layoutManager: NSLayoutManager)
}
