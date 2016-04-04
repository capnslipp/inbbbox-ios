//
//  ShotDetailsViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import ZFDragableModalTransition
import TTTAttributedLabel

protocol UICollectionViewCellWithLabelContainingClickableLinksDelegate: class {
    
    func labelContainingClickableLinksDidTap(gestureRecognizer: UITapGestureRecognizer, textContainer: NSTextContainer, layoutManager: NSLayoutManager)
}

final class ShotDetailsViewController: UIViewController {
    
    var shouldScrollToMostRecentMessage = false
    
    private var shotDetailsView: ShotDetailsView {
        return view as! ShotDetailsView
    }
    private var header: ShotDetailsHeaderView?
    private var footer: ShotDetailsFooterView?
    private let viewModel: ShotDetailsViewModel
    private var scroller = ScrollViewAutoScroller()
    private var onceTokenForShouldScrollToMessagesOnOpenFlag = dispatch_once_t(0)
    private var modalTransitionAnimator: ZFModalTransitionAnimator?
    
    init(shot: ShotType) {
        self.viewModel = ShotDetailsViewModel(shot: shot)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message="Use init(shot:) instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    @available(*, unavailable, message="Use init(shot:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ShotDetailsView(frame: CGRectZero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroller.scrollView = shotDetailsView.collectionView
   
        shotDetailsView.topLayoutGuideOffset = UIApplication.sharedApplication().statusBarFrame.size.height
        shotDetailsView.collectionView.delegate = self
        shotDetailsView.collectionView.dataSource = self
        shotDetailsView.collectionView.registerClass(ShotDetailsCommentCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsOperationCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsDescriptionCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsDummySpaceCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsFooterView.self, type: .Footer)
        shotDetailsView.collectionView.registerClass(ShotDetailsHeaderView.self, type: .Header)
        shotDetailsView.commentComposerView.delegate = self
        shotDetailsView.keyboardResizableView.delegate = self
        shotDetailsView.shouldShowCommentComposerView = viewModel.isCommentingAvailable
        
        firstly {
            viewModel.loadAllComments()
        }.then { () -> Void in
            self.grayOutFooterIfNeeded()
            self.shotDetailsView.collectionView.reloadData()
            self.scroller.scrollToBottomAnimated(true)
        }.error { error in
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = shotDetailsView.collectionView.collectionViewLayout as? ShotDetailsCollectionCollapsableViewStickyHeader {
            layout.collapsableHeight = heightForCollapsedCollectionViewHeader
            layout.invalidateLayout()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_once(&onceTokenForShouldScrollToMessagesOnOpenFlag) {
            if self.shouldScrollToMostRecentMessage {
                self.viewModel.isCommentingAvailable ? self.shotDetailsView.commentComposerView.makeActive() : self.scroller.scrollToBottomAnimated(true)
            }
        }

        AnalyticsManager.trackScreen(.ShotDetailsView)
    }
}

// MARK: UICollectionViewDataSource
extension ShotDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if viewModel.isShotOperationIndex(indexPath.row) {
            let cell = collectionView.dequeueReusableClass(ShotDetailsOperationCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let likeSelectableView = cell.operationView.likeSelectableView
            let bucketSelectableView = cell.operationView.bucketSelectableView
            
            likeSelectableView.tapHandler = { [weak self] in
                self?.likeSelectableViewDidTap(likeSelectableView)
            }
            
            bucketSelectableView.tapHandler = { [weak self] in
                self?.bucketSelectableViewDidTap(bucketSelectableView)
            }
            
            setLikeStateInSelectableView(likeSelectableView)
            setBucketStatusInSelectableView(bucketSelectableView)
            
            return cell
            
        } else if viewModel.isDescriptionIndex(indexPath.row) {

            let cell = collectionView.dequeueReusableClass(ShotDetailsDescriptionCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            if let description = viewModel.attributedShotDescription {
                cell.setDescriptionLabelAttributedText(description)
            }
            cell.delegate = self

            return cell
            
        } else if viewModel.shouldDisplaySeparatorAtIndex(indexPath.row) {
            return collectionView.dequeueReusableClass(ShotDetailsDummySpaceCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
        } else {
            let cell = collectionView.dequeueReusableClass(ShotDetailsCommentCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let data = viewModel.displayableDataForCommentAtIndex(indexPath.row)

            cell.authorLabel.setText(data.author)
            if let comment = data.comment {
                cell.setCommentLabelAttributedText(comment)
            }
            let user = viewModel.userForCommentAtIndex(indexPath.row)
            if let url = viewModel.urlForUser(user) {
                cell.setLinkInAuthorLabel(url, delegate: self)
            }
            cell.dateLabel.attributedText = data.date
            cell.avatarView.imageView.loadImageFromURLString(data.avatarURLString, placeholderImage: UIImage(named: "avatar_placeholder"))
            cell.deleteActionHandler = { [weak self] in
                self?.deleteCommentAtIndexPath(indexPath)
            }
            cell.avatarView.delegate = self
            cell.delegate = self

            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            
            footer = collectionView.dequeueReusableClass(ShotDetailsFooterView.self, forIndexPath: indexPath, type: .Footer)
            viewModel.isFetchingComments ? footer?.startAnimating() : footer?.stopAnimating()
            grayOutFooterIfNeeded()
            
            return footer!
        }
        
        if header == nil && kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            if viewModel.shot.animated {
                if let url = viewModel.shot.shotImage.hidpiURL {
                    header?.setAnimatedImageWithUrl(url)
                } else {
                    header?.setAnimatedImageWithUrl(viewModel.shot.shotImage.normalURL)
                }
            } else {
                header?.setImageWithUrl(viewModel.shot.shotImage.normalURL)
            }
            
            header?.maxHeight = sizeForExpandedCollectionViewHeader(collectionView).height
            header?.minHeight = heightForCollapsedCollectionViewHeader
            
            header?.setAttributedTitle(viewModel.attributedShotTitleForHeader)
            if let url = viewModel.urlForUser(viewModel.shot.user) {
                header?.setLinkInTitle(url, range: viewModel.userLinkRange, delegate: self)
            }
            header?.avatarView.imageView.loadImageFromURLString(viewModel.shot.user.avatarString ?? "")
            header?.closeButtonView.closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
            header?.avatarView.delegate = self
        }
        
        return header!
    }
}

// MARK: UICollectionViewDelegate
extension ShotDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if collectionView.cellForItemAtIndexPath(indexPath) is ShotDetailsCommentCollectionViewCell {
            return viewModel.isCurrentUserOwnerOfCommentAtIndex(indexPath.row)
        }
        return false
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ShotDetailsCommentCollectionViewCell {
            cell.showEditView(true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if viewModel.isShotOperationIndex(indexPath.row) {
            return collectionView.sizeForAutoSizingCell(ShotDetailsOperationCollectionViewCell.self, textToBound: nil)
        
        } else if viewModel.isDescriptionIndex(indexPath.row) {
            let text = viewModel.attributedShotDescription
            return collectionView.sizeForAutoSizingCell(ShotDetailsDescriptionCollectionViewCell.self, textToBound: [text])
            
        } else if viewModel.shouldDisplaySeparatorAtIndex(indexPath.row) {
            return collectionView.sizeForAutoSizingCell(ShotDetailsDummySpaceCollectionViewCell.self, textToBound: nil)
            
        } else {
            let data = viewModel.displayableDataForCommentAtIndex(indexPath.row)
            let text = [data.author, data.comment, data.date]
            return collectionView.sizeForAutoSizingCell(ShotDetailsCommentCollectionViewCell.self, textToBound: text)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ShotDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForExpandedCollectionViewHeader(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = viewModel.isFetchingComments ? 64 : ShotDetailsFooterView.minimumRequiredHeight
        return CGSize(width: CGRectGetWidth(collectionView.frame), height: height)
    }
}

// MARK: Actions
extension ShotDetailsViewController {
    
    func closeButtonDidTap(_: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: CommentComposerViewDelegate
extension ShotDetailsViewController: CommentComposerViewDelegate {
    
    func didTapSendButtonInComposerView(view: CommentComposerView, comment: String) {
        
        view.startAnimation()
        
        firstly {
            viewModel.postComment(comment)
        }.then { () -> Void in
            
            let indexPath = NSIndexPath(forItem: self.shotDetailsView.collectionView.numberOfItemsInSection(0), inSection: 0)
            self.shotDetailsView.collectionView.performBatchUpdates({ () -> Void in
                self.shotDetailsView.collectionView.insertItemsAtIndexPaths([indexPath])
            }, completion: { _ -> Void in
                self.shotDetailsView.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
            })
        }.always {
            view.stopAnimation()
        }.error { error in
            print(error)
        }
    }
    
    func commentComposerViewDidBecomeActive(view: CommentComposerView) {
        scroller.scrollToBottomAnimated(true)
    }
}

extension ShotDetailsViewController: KeyboardResizableViewDelegate {
    
    func keyboardResizableView(view: KeyboardResizableView, didRelayoutSubviewsWithState state: KeyboardState) {
        // intentionally left blank.
    }
    
    func keyboardResizableView(view: KeyboardResizableView, willRelayoutSubviewsWithState state: KeyboardState) {
        let round = state == .WillAppear
        shotDetailsView.commentComposerView.animateByRoundingCorners(round)
    }
}

extension ShotDetailsViewController: ModalByDraggingClosable {
    var scrollViewToObserve: UIScrollView {
        return shotDetailsView.collectionView
    }
}

private extension ShotDetailsViewController {

    func setLikeStateInSelectableView(view: ActivityIndicatorSelectableView) {
        handleSelectableViewStatus(view) {
            self.viewModel.checkLikeStatusOfShot()
        }
    }

    func setBucketStatusInSelectableView(view: ActivityIndicatorSelectableView) {
        handleSelectableViewStatus(view) {
            self.viewModel.checkShotAffiliationToUserBuckets()
        }
    }

    func handleSelectableViewStatus(view: ActivityIndicatorSelectableView, withAction action: (() -> Promise<Bool>)) {

        view.startAnimating()
            
        firstly {
            action()
        }.then { selected in
            view.selected = selected
        }.always {
            view.stopAnimating()
        }.error { error in
            print(error)
        }
    }
    
    func likeSelectableViewDidTap(view: ActivityIndicatorSelectableView) {

        view.startAnimating()
        
        firstly {
            viewModel.performLikeOperation()
        }.then { isShotLikedByUser in
            view.selected = isShotLikedByUser
        }.always {
            view.stopAnimating()
        }.error { error in
            print(error)
        }
    }
    
    func bucketSelectableViewDidTap(view: ActivityIndicatorSelectableView) {
        
        view.startAnimating()
        
        firstly{
            viewModel.removeShotFromBucketIfExistsInExactlyOneBucket()
        }.then { result -> Void in
            if let bucketNumber = result.bucketsNumber where !result.removed {
                let mode: ShotBucketsViewControllerMode = bucketNumber == 0 ? .AddToBucket : .RemoveFromBucket
                self.presentShotBucketsViewControllerWithMode(mode)
            } else {
                view.selected = false
            }
        }.always {
            view.stopAnimating()
        }.error { error in
            print(error)
        }
    }
    
    var heightForCollapsedCollectionViewHeader: CGFloat {
        
        let margin = CGFloat(20)
        let maxWidth = abs((shotDetailsView.collectionView.frame.size.width ?? 0) - (header?.availableWidthForTitle ?? 0))
        let height = viewModel.attributedShotTitleForHeader.boundingHeightUsingAvailableWidth(maxWidth) + 2 * margin
        
        return max(70, height)
    }
    
    func sizeForExpandedCollectionViewHeader(collectionView: UICollectionView) -> CGSize {
        let dribbbleImageRatio = CGFloat(0.75)
        return CGSize(
            width: floor(collectionView.bounds.width),
            height: ceil(collectionView.bounds.width * dribbbleImageRatio + heightForCollapsedCollectionViewHeader)
        )
    }
    
    func deleteCommentAtIndexPath(indexPath: NSIndexPath) {
        firstly {
            viewModel.deleteCommentAtIndex(indexPath.item)
        }.then { () -> Void in
            self.shotDetailsView.collectionView.deleteItemsAtIndexPaths([indexPath])
        }.error { error in
            print(error)
        }
    }

    func presentShotBucketsViewControllerWithMode(mode: ShotBucketsViewControllerMode) {
        
        let shotBucketsViewController = ShotBucketsViewController(shot: viewModel.shot, mode: mode)
        animateHeader(start: false)
        shotBucketsViewController.dismissClosure =  { [weak self] in
            guard let certainSelf = self else { return }
            self?.animateHeader(start: true)
            certainSelf.viewModel.clearBucketsData()
            certainSelf.shotDetailsView.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
        }
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotBucketsViewController)
        shotBucketsViewController.transitioningDelegate = modalTransitionAnimator
        shotBucketsViewController.modalPresentationStyle = .Custom
        presentViewController(shotBucketsViewController, animated: true, completion: nil)
    }
    
    func presentUserDetailsViewControllerForUser(user: UserType) {
        
        let userDetailsViewController = UserDetailsViewController(user: user)
        let navigationController = UINavigationController(rootViewController: userDetailsViewController)
        
        animateHeader(start: false)
        userDetailsViewController.dismissClosure = { [weak self] in
            self?.animateHeader(start: true)
        }
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func animateHeader(start start: Bool) {
        if let imageView = header?.imageView as? AnimatableShotImageView {
            start ? imageView.startAnimatingGIF() : imageView.stopAnimatingGIF()
        }
    }
    
    func grayOutFooterIfNeeded() {
        let shouldGrayOut = !viewModel.hasComments && !viewModel.hasDescription
        footer?.grayOutBackground(shouldGrayOut)
    }
}

// MARK: UICollectionViewCellWithLabelContainingClickableLinksDelegate

extension ShotDetailsViewController: UICollectionViewCellWithLabelContainingClickableLinksDelegate {
    
    func labelContainingClickableLinksDidTap(gestureRecognizer: UITapGestureRecognizer, textContainer: NSTextContainer, layoutManager: NSLayoutManager) {
        
        guard let view = gestureRecognizer.view else { return }
        
        var locationOfTouchInLabel = gestureRecognizer.locationInView(gestureRecognizer.view)
        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        
        let textOffset: CGPoint = {
            var textOffset = CGPointZero
            let textBounds = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
            let paddingHeight = (view.bounds.size.height - textBounds.size.height) / 2;
            if paddingHeight > 0 {
                textOffset.y = paddingHeight;
            }
            return textOffset;
        }()

        locationOfTouchInLabel.x -= textOffset.x;
        locationOfTouchInLabel.y -= textOffset.y;
        
        let glyphIndex = layoutManager.glyphIndexForPoint(locationOfTouchInLabel, inTextContainer: textContainer)
        let locationIndex = layoutManager.characterIndexForGlyphAtIndex(glyphIndex)
        
        let url = (view as? UILabel)?.attributedText?.attribute(NSLinkAttributeName, atIndex: locationIndex, effectiveRange: nil) as? NSURL
        
        if let url = url {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

extension ShotDetailsViewController: AvatarViewDelegate {
    
    func avatarView(avatarView: AvatarView, didTapButton avatarButton: UIButton) {
        var user: UserType?
        if avatarView.superview == header {
            user = viewModel.shot.user
        } else if (avatarView.superview?.superview is ShotDetailsCommentCollectionViewCell) {
            let cell = avatarView.superview!.superview! as! ShotDetailsCommentCollectionViewCell
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

extension ShotDetailsViewController: TTTAttributedLabelDelegate {
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        if let user = viewModel.userForURL(url) {
            presentUserDetailsViewControllerForUser(user)
        }
    }
}

extension ShotDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        animateHeader(start: false)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            animateHeader(start: true)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        animateHeader(start: true)
    }
}
