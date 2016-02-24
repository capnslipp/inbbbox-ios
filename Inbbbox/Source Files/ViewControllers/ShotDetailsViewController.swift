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
    
    private weak var aView: ShotDetailsView?
    private var header: ShotDetailsHeaderView?
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
        aView = loadViewWithClass(ShotDetailsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            viewModel.loadComments()
        }.then {
            self.aView?.collectionView.reloadData()
        }.error { error in
            print(error)
        }
        
        guard let view = aView else {
            return
        }
        
        view.topLayoutGuideOffset = UIApplication.sharedApplication().statusBarFrame.size.height
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.registerClass(ShotDetailsCommentCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotDetailsOperationCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotDetailsDescriptionCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotDetailsHeaderView.self, type: .Header)
        view.closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
        view.commentComposerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setEstimatedSizeIfNeeded()
        (aView?.collectionView.collectionViewLayout as? ShotDetailsCollectionCollapsableViewStickyHeader)?.collapsableHeight = heightForCollapsedCollectionViewHeader
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
            
            cell.operationView.likeButton.addTarget(self, action: "likeButtonDidTap:", forControlEvents: .TouchUpInside)
            cell.operationView.bucketButton.addTarget(self, action: "bucketButtonDidTap:", forControlEvents: .TouchUpInside)

            // NGRToDo:
            // use set selected for distinguish images
            
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
            cell.avatarView.imageView.loadImageFromURLString(data.avatarURLString)
            cell.deleteActionHandler = { [weak self] in
                //NGRToDo: attach action
                self?.presentTempAlertController()
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if header == nil && kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            header?.imageView.loadShotImageFromURL(viewModel.shot.shotImage.normalURL)
            
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
}

// MARK: Actions
extension ShotDetailsViewController {
    
    func closeButtonDidTap(_: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func likeButtonDidTap(_: UIButton) {
        //NGRToDo: attach action
        presentTempAlertController()
    }
    
    func bucketButtonDidTap(_: UIButton) {
        //NGRToDo: attach action
        presentTempAlertController()
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
    
    var heightForCollapsedCollectionViewHeader: CGFloat {
        
        let margin = CGFloat(5)
        let maxWidth = abs((aView?.collectionView.frame.size.width ?? 0) - (header?.availableWidthForTitle ?? 0))
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
        
        let width = aView?.collectionView.frame.size.width ?? 0
        if let layout = aView?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout where layout.estimatedItemSize.width != width {
            layout.estimatedItemSize = CGSize(width: width, height: 100)
            layout.invalidateLayout()
        }
    }
}
