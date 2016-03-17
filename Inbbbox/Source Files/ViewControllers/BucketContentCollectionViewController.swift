//
//  BucketContentCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 15.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import ZFDragableModalTransition
import DZNEmptyDataSet

class BucketContentCollectionViewController: TwoLayoutsCollectionViewController {
    
    var viewModel: BucketContentViewModel?
    var modalTransitionAnimator: ZFModalTransitionAnimator?
    private var canEmptyDataBeVisible = false
    
    // MARK: - Lifecycle
    
    convenience init(bucket: BucketType) {
        self.init(oneColumnLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio, twoColumnsLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio)
        self.viewModel = BucketContentViewModel(bucket: bucket)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        self.title = viewModel?.title
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(SimpleShotCollectionViewCell.self, type: .Cell)
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.clearViewModelIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.downloadInitialItems()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.itemsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(SimpleShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.image = nil
        let cellData = viewModel!.shotCollectionViewCellViewData(indexPath)
        cell.shotImageView.loadImageFromURL(cellData.imageURL)
        cell.gifLabel.hidden = !cellData.animated
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel!.itemsCount {
            viewModel?.downloadItemsForNextPage()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        let shotDetailsViewController = ShotDetailsViewController(shot: viewModel.shots[indexPath.item])
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)
        
        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom
        
        tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }
}

extension BucketContentCollectionViewController: BaseCollectionViewViewModelDelegate {
    
    func viewModelDidLoadInitialItems() {
        canEmptyDataBeVisible = true
        collectionView?.reloadData()
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

extension BucketContentCollectionViewController: DZNEmptyDataSetSource {
    
    func imageForEmptyDataSet(_: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo-empty")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let firstLocalizedString = NSLocalizedString("Add some shots\nto this bucket ", comment: "")
       
        let compoundAttributedString = NSMutableAttributedString.emptyDataSetStyledString(firstLocalizedString)
        let textAttachment: NSTextAttachment = NSTextAttachment()
        
        textAttachment.image = UIImage(named: "ic-bucket-emptystate")
        if let image = textAttachment.image {
            textAttachment.bounds = CGRect(x: 0, y: -4, width: image.size.width, height: image.size.height)
        }
        
        let attributedStringWithImage: NSAttributedString = NSAttributedString(attachment: textAttachment)
        compoundAttributedString.appendAttributedString(attributedStringWithImage)
        
        let lastLocalizedString = NSLocalizedString(" first", comment: "")
        let lastAttributedString = NSMutableAttributedString.emptyDataSetStyledString(lastLocalizedString)
        
        compoundAttributedString.appendAttributedString(lastAttributedString)
        return compoundAttributedString
    }
    
    func spaceHeightForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func verticalOffsetForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return -40
    }
}

extension BucketContentCollectionViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return canEmptyDataBeVisible
    }
}
