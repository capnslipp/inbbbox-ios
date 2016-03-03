//
//  ShotDetailsViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import KFSwiftImageLoader

class ShotDetailsViewController: UIViewController {
    
    var shotDetailsView: ShotDetailsView {
        return view as! ShotDetailsView
    }
    private var header: ShotDetailsHeaderView?
    private var footer: ShotDetailsFooterView?
    private let viewModel: ShotDetailsViewModel
    
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
   
        shotDetailsView.topLayoutGuideOffset = UIApplication.sharedApplication().statusBarFrame.size.height
        shotDetailsView.collectionView.delegate = self
        shotDetailsView.collectionView.dataSource = self
        shotDetailsView.collectionView.registerClass(ShotDetailsCommentCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsOperationCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsDescriptionCollectionViewCell.self, type: .Cell)
        shotDetailsView.collectionView.registerClass(ShotDetailsFooterView.self, type: .Footer)
        shotDetailsView.collectionView.registerClass(ShotDetailsHeaderView.self, type: .Header)
        shotDetailsView.closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        shotDetailsView.commentComposerView.delegate = self
        shotDetailsView.shouldShowCommentComposerView = viewModel.isCommentingAvailable
        
        firstly {
            viewModel.loadComments()
        }.then { () -> Void in
            if self.viewModel.commentsCount == 0 && self.viewModel.attributedShotDescription == nil {
                self.footer?.grayOutBackground()
            }
            self.shotDetailsView.collectionView.reloadData()
        }.error { error in
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setEstimatedSizeIfNeeded()
        (shotDetailsView.collectionView.collectionViewLayout as? ShotDetailsCollectionCollapsableViewStickyHeader)?.collapsableHeight = heightForCollapsedCollectionViewHeader
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
            
            cell.descriptionLabel.attributedText = viewModel.attributedShotDescription
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableClass(ShotDetailsCommentCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let data = viewModel.displayableDataForCommentAtIndex(indexPath.row)
            
            cell.authorLabel.text = data.author
            cell.commentLabel.attributedText = data.comment
            cell.dateLabel.text = data.date
            cell.avatarView.imageView.loadImageFromURLString(data.avatarURLString, placeholderImage: UIImage(named: "avatar_placeholder"), completion: nil)
            cell.deleteActionHandler = { [weak self] in
                self?.deleteCommentAtIndexPath(indexPath)
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            
            if footer == nil {
                footer = collectionView.dequeueReusableClass(ShotDetailsFooterView.self, forIndexPath: indexPath, type: .Footer)
                footer?.tapHandler = { [weak self] in
                    
                    guard let this = self else { return }
                    this.footer?.startAnimating()
                    
                    let collectionView = this.shotDetailsView.collectionView
                    firstly {
                        this.viewModel.loadComments()
                    }.then { () -> Void in
                        collectionView.reloadData()
                    }.always {
                        this.footer?.stopAnimating()
                    }.error { error in
                        print(error)
                    }
                }
            }
            
            viewModel.isFetchingComments ? footer?.startAnimating() : footer?.stopAnimating()
            footer?.shouldShowLoadMoreButton = viewModel.hasMoreCommentsToFetch && !viewModel.isFetchingComments
            footer?.setTitleForCount(viewModel.commentsLeftToFetch)
            
            return footer!
        }
        
        if header == nil && kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            if let url = viewModel.shot.shotImage.hidpiURL where viewModel.shot.animated {
                header?.setAnimatedImageWithUrl(url)
            } else {
                header?.setImageWithUrl(viewModel.shot.shotImage.normalURL)
            }
            
            header?.maxHeight = sizeForExpandedCollectionViewHeader(collectionView).height
            header?.minHeight = heightForCollapsedCollectionViewHeader
            
            header?.setAttributedTitle(viewModel.attributedShotTitleForHeader)
            header?.avatarView.imageView.loadImageFromURLString(viewModel.shot.user.avatarString ?? "")
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
}

// MARK: UICollectionViewDelegateFlowLayout
extension ShotDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForExpandedCollectionViewHeader(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = {
            if viewModel.isFetchingComments {
                return 44
            }
            return viewModel.hasMoreCommentsToFetch ? 54 : ShotDetailsFooterView.minimumRequiredHeight
        }()
        return CGSize(width: CGRectGetWidth(collectionView.frame), height: height)
    }
}

// MARK: Actions
extension ShotDetailsViewController {
    
    func closeButtonDidTap(_: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ShotDetailsViewController: CommentComposerViewDelegate {
    
    func didTapSendButtonInComposerView(view: CommentComposerView, withComment: String?) {
        presentTempAlertController()
    }
}

private extension ShotDetailsViewController {

    func presentTempAlertController() {
        let controller = UIAlertController(title: "Oh no!", message: "This function is not supported yet", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Destructive) { _ in
            controller.dismissViewControllerAnimated(true, completion: nil)
        }

        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }

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
        
        let margin = CGFloat(5)
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
    
    func setEstimatedSizeIfNeeded() {
        
        let width = shotDetailsView.collectionView.frame.size.width ?? 0
        if let layout = shotDetailsView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout where layout.estimatedItemSize.width != width {
            layout.estimatedItemSize = CGSize(width: width, height: 100)
            layout.invalidateLayout()
        }
    }
    
    func deleteCommentAtIndexPath(indexPath: NSIndexPath) {
        firstly {
            viewModel.deleteCommentAtIndex(indexPath.item)
        }.then {
            self.shotDetailsView.collectionView.deleteItemsAtIndexPaths([indexPath])
        }.error { error in
            print(error)
        }
    }
    
    func presentShotBucketsViewControllerWithMode(mode: ShotBucketsViewControllerMode) {
        
        let shotBucketsViewController = ShotBucketsViewController(shot: viewModel.shot, mode: mode)
        
        shotBucketsViewController.dismissClosure =  { [weak self] in
            
            guard let certainSelf = self else { return }
            
            certainSelf.viewModel.clearBucketsData()
            certainSelf.shotDetailsView.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
        }
        shotBucketsViewController.modalPresentationStyle = .OverFullScreen
        presentViewController(shotBucketsViewController, animated: true, completion: nil)
    }
}
