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

class LikesCollectionViewController: TwoLayoutsCollectionViewController {
    
    let viewModel = LikesViewModel()
    var modalTransitionAnimator: ZFModalTransitionAnimator?
    private var shouldShowLoadingView = true
    
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
        viewModel.clearViewModelIfNeeded()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadInitialItems()
        AnalyticsManager.trackScreen(.LikesView)
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
}

extension LikesCollectionViewController : BaseCollectionViewViewModelDelegate {
    
    func viewModelDidLoadInitialItems() {
        self.shouldShowLoadingView = false
        collectionView?.reloadData()
    }
    
    func viewModelDidFailToLoadInitialItems(error: ErrorType) {
        self.shouldShowLoadingView = false
        collectionView?.reloadData()
        
        if viewModel.likedShots.isEmpty {
            let alert = UIAlertController.generalErrorAlertController()
            presentViewController(alert, animated: true, completion: nil)
            alert.view.tintColor = .pinkColor()
        }
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

extension LikesCollectionViewController: DZNEmptyDataSetSource {
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        
        if shouldShowLoadingView {
            let loadingView = EmptyDataSetLoadingView.newAutoLayoutView()
            loadingView.startAnimation()
            return loadingView
        } else {
            let emptyDataSetView = EmptyDataSetView.newAutoLayoutView()
            emptyDataSetView.setDescriptionText(
                firstLocalizedString: NSLocalizedString("Like ", comment: ""),
                attachmentImage: UIImage(named: "ic-like-emptystate"),
                imageOffset: CGPoint(x: 0, y: -2),
                lastLocalizedString: NSLocalizedString(" some shots first!", comment: "")
            )
            return emptyDataSetView
        }
    }
}
