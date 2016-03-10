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
    
    var shotBucketsView: ShotBucketsView {
        return view as! ShotBucketsView
    }
    
    var dismissClosure: (() -> Void)?
    
    private var header: ShotBucketsHeaderView?
    private var footer: ShotBucketsFooterView?
    private let viewModel: ShotBucketsViewModel
    
    init(shot: ShotType, mode: ShotBucketsViewControllerMode) {
        viewModel = ShotBucketsViewModel(shot: shot, mode: mode)
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
        view = loadViewWithClass(ShotBucketsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            viewModel.loadBuckets()
        }.then {
            self.shotBucketsView.collectionView.reloadData()
        }.error { error in
            print(error)
        }
        
        shotBucketsView.topLayoutGuideOffset = UIApplication.sharedApplication().statusBarFrame.size.height
        shotBucketsView.collectionView.delegate = self
        shotBucketsView.collectionView.dataSource = self
        shotBucketsView.collectionView.registerClass(ShotBucketsAddCollectionViewCell.self, type: .Cell)
        shotBucketsView.collectionView.registerClass(ShotBucketsSelectCollectionViewCell.self, type: .Cell)
        shotBucketsView.collectionView.registerClass(ShotBucketsRemoveCollectionViewCell.self, type: .Cell)
        shotBucketsView.collectionView.registerClass(ShotBucketsSeparatorCollectionViewCell.self, type: .Cell)
        shotBucketsView.collectionView.registerClass(ShotBucketsHeaderView.self, type: .Header)
        shotBucketsView.collectionView.registerClass(ShotBucketsFooterView.self, type: .Footer)
        shotBucketsView.closeButton.addTarget(self, action: "closeButtonDidTap:", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setEstimatedSizeIfNeeded()
        (shotBucketsView.collectionView.collectionViewLayout as? ShotDetailsCollectionCollapsableViewStickyHeader)?.collapsableHeight = heightForCollapsedCollectionViewHeader
    }
}

// MARK: UICollectionViewDataSource
extension ShotBucketsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
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
        } else if let _ = collectionView.cellForItemAtIndexPath(indexPath) as? ShotBucketsAddCollectionViewCell {
            addShotToBucketAtIndexPath(indexPath)
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
        firstly {
            viewModel.removeShotFromSelectedBuckets()
        }.then { () -> Void in
            self.dismissClosure?()
            self.dismissViewControllerAnimated(true, completion: nil)
        }.error { error in
            print(error)
        }
    }
}

private extension ShotBucketsViewController {
    
    var heightForCollapsedCollectionViewHeader: CGFloat {
        
        let margin = CGFloat(5)
        let maxWidth = abs((shotBucketsView.collectionView.frame.size.width ?? 0) - (header?.availableWidthForTitle ?? 0))
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
        
        let width = shotBucketsView.collectionView.frame.size.width ?? 0
        if let layout = shotBucketsView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout where layout.estimatedItemSize.width != width {
            layout.estimatedItemSize = CGSize(width: width, height: 40)
            layout.invalidateLayout()
        }
    }
    
    func backgroundColorForFooter() -> UIColor {
        switch viewModel.shotBucketsViewControllerMode {
        case .AddToBucket:
            return .whiteColor() // color same as cell's background
        case .RemoveFromBucket:
            return .RGBA(246, 248, 248, 1) // color same as header title background
        }
    }
    
    func configureCellForAddToBucketMode(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotBucketsAddCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        
        let bucketData = viewModel.displayableDataForBucketAtIndex(indexPath.item)
        cell.bucketNameLabel.text = bucketData.bucketName
        cell.shotsCountLabel.text = bucketData.shotsCountText
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
            
            let bucketData = viewModel.displayableDataForBucketAtIndex(indexPath.item)
            cell.bucketNameLabel.text = bucketData.bucketName
            cell.selectBucket(viewModel.bucketShouldBeSelectedAtIndex(indexPath.item))
            cell.showBottomSeparator(viewModel.showBottomSeparatorForBucketAtIndex(indexPath.item))
            return cell
        }
    }
    
    func addShotToBucketAtIndexPath(indexPath: NSIndexPath) {
        firstly {
            viewModel.addShotToBucketAtIndex(indexPath.item)
        }.then { () -> Void in
            self.dismissClosure?()
            self.dismissViewControllerAnimated(true, completion: nil)
        }.error { error in
            print(error)
        }
    }
}
