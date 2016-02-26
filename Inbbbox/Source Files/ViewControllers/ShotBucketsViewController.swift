//
//  ShotBucketsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 24/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

enum ShotBucketsViewControllerMode {
    case AddToBucket
    case RemoveFromBucket
}

class ShotBucketsViewController: UIViewController {
    
    private weak var aView: ShotBucketsView?
    private var header: ShotBucketsHeaderView?
    private var footer: ShotBucketsFooterView?
    private let viewModel: ShotBucketsViewModel
    
    init(shot: Shot, mode: ShotBucketsViewControllerMode) {
        self.viewModel = ShotBucketsViewModel(shot: shot, mode: mode)
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
        aView = loadViewWithClass(ShotBucketsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NGRTodo: collect data to display (buckets)
        
        guard let view = aView else {
            return
        }
        
        view.topLayoutGuideOffset = UIApplication.sharedApplication().statusBarFrame.size.height
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.registerClass(ShotBucketsAddCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotBucketsSelectCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotBucketsRemoveCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotBucketsSeparatorCollectionViewCell.self, type: .Cell)
        view.collectionView.registerClass(ShotBucketsHeaderView.self, type: .Header)
        view.collectionView.registerClass(ShotBucketsFooterView.self, type: .Footer)
        view.closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setEstimatedSizeIfNeeded()
        (aView?.collectionView.collectionViewLayout as? ShotDetailsCollectionCollapsableViewStickyHeader)?.collapsableHeight = heightForCollapsedCollectionViewHeader
    }
}

// MARK: UICollectionViewDataSource
extension ShotBucketsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 //NGRTemp: should be viewModel.itemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch viewModel.shotBucketsViewControllerMode {
        case .AddToBucket:
            return configureCellForAddToBucketMode(collectionView, atIndexPath: indexPath)
        case .RemoveFromBucket:
            return configureCellForRemoveFromBucketMode(collectionView, atIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            if header == nil && kind == UICollectionElementKindSectionHeader {
                header = collectionView.dequeueReusableClass(ShotBucketsHeaderView.self, forIndexPath: indexPath, type: .Header)
                header?.imageView.loadShotImageFromURL(viewModel.shot.image.normalURL)
                
                header?.maxHeight = sizeForExpandedCollectionViewHeader(collectionView).height
                header?.minHeight = heightForCollapsedCollectionViewHeader
                
                header?.setAttributedTitle(viewModel.attributedShotTitleForHeader)
                header?.setHeaderTitle(viewModel.titleForHeader)
                header?.avatarView.imageView.loadImageFromURLString(viewModel.shot.user.avatarString ?? "")
            }
            return header!
        } else {
            if footer == nil {
                footer = collectionView.dequeueReusableClass(ShotBucketsFooterView.self, forIndexPath: indexPath, type: .Footer)
                footer?.backgroundColor = backgroundColorForFooter()
            }
            return footer!
        }
    }
}

// MARK: UICollectionViewDelegate
extension ShotBucketsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ShotBucketsSelectCollectionViewCell {
            cell.selectBucket(viewModel.selectBucketAtIndex(indexPath.item))
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ShotBucketsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForExpandedCollectionViewHeader(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: floor(collectionView.bounds.width), height: 20)
    }
}

// MARK: Actions
extension ShotBucketsViewController {
    
    func closeButtonDidTap(_: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func removeButtonDidTap(_: UIButton) {
        presentTempAlertController()
    }
}


private extension ShotBucketsViewController {
    
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
            layout.estimatedItemSize = CGSize(width: width, height: 40)
            layout.invalidateLayout()
        }
    }
    
    func backgroundColorForFooter() -> UIColor {
        switch viewModel.shotBucketsViewControllerMode {
        case .AddToBucket:
            return .RGBA(255, 255, 255, 1)
        case .RemoveFromBucket:
            return .RGBA(246, 248, 248, 1)
        }
    }
    
    func configureCellForAddToBucketMode(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotBucketsAddCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.bucketNameLabel.text = "Awesome UI/UX" // NGRTemp: temp text
        cell.shotsCountLabel.text = "2 shots" // NGRTemp: temp text
        cell.showBottomSeparator(viewModel.showBottomSeparatorForBucketAtIndex(indexPath.item))
        return cell
    }
    
    func configureCellForRemoveFromBucketMode(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if viewModel.isSeparatorCellAtIndex(indexPath.item) {
            return collectionView.dequeueReusableClass(ShotBucketsSeparatorCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        } else if viewModel.isRemoveCellAtIndex(indexPath.item) {
            let cell = collectionView.dequeueReusableClass(ShotBucketsRemoveCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.removeButton.addTarget(self, action: "removeButtonDidTap:", forControlEvents: .TouchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(ShotBucketsSelectCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.bucketNameLabel.text = "Awesome UI/UX" // NGRTemp: temp text
            cell.selectBucket(viewModel.bucketShouldBeSelectedAtIndex(indexPath.item))
            cell.showBottomSeparator(viewModel.showBottomSeparatorForBucketAtIndex(indexPath.item))
            return cell
        }
    }
}
