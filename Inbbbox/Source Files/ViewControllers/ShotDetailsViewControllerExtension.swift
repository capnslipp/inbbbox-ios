//
//  ShotDetailsViewControllerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 02/05/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ImageViewer

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
