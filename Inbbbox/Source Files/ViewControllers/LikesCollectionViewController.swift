//
//  LikesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import ZFDragableModalTransition
import DZNEmptyDataSet

class LikesCollectionViewController: TwoLayoutsCollectionViewController, BaseCollectionViewViewModelDelegate, DZNEmptyDataSetSource {
    
    let viewModel = LikesViewModel()
    var modalTransitionAnimator: ZFModalTransitionAnimator?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.title = viewModel.title
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(SimpleShotCollectionViewCell.self, type: .Cell)
        collectionView.emptyDataSetSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.trackScreen(.LikesView)
        viewModel.clearViewModelIfNeeded()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadInitialItems()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(SimpleShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.image = nil
        let cellData = viewModel.shotCollectionViewCellViewData(indexPath)
        cell.shotImageView.loadImageFromURL(cellData.imageURL)
        cell.gifLabel.hidden = !cellData.animated
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount {
            viewModel.downloadItemsForNextPage()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let shotDetailsViewController = ShotDetailsViewController(shot: viewModel.likedShots[indexPath.item])
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)
        
        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom
        
        tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }
    
    // MARK: Base Collection View View Model Delegate
    
    func viewModelDidLoadInitialItems() {
        if self.viewModel.likedShots.count == 0 {
            collectionView!.emptyDataSetSource = self
        }
        collectionView?.reloadData()
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
    
    // MARK: Empty Data Set Data Source Methods
    
    func imageForEmptyDataSet(_: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo-empty")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let localizedString = NSLocalizedString("Like   some shots first!", comment: "")
        let attributedString = NSMutableAttributedString.emptyDataSetStyledString(localizedString)
        
        let textAttachment: NSTextAttachment = NSTextAttachment()
        
        textAttachment.image = UIImage(named: "ic-like-emptystate")
        if let image = textAttachment.image {
            textAttachment.bounds = CGRect(x: 0, y: -2, width: image.size.width, height: image.size.height)
        }
        
        let attributedStringWithImage: NSAttributedString = NSAttributedString(attachment: textAttachment)
        
        attributedString.replaceCharactersInRange(NSMakeRange(5, 1), withAttributedString: attributedStringWithImage)
        return attributedString
    }
    
    func spaceHeightForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func verticalOffsetForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return -40
    }
}
