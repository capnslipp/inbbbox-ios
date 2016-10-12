//
//  FolloweesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import DZNEmptyDataSet

class FolloweesCollectionViewController: TwoLayoutsCollectionViewController {

    // MARK: - Lifecycle

    private let viewModel = FolloweesViewModel()
    private var shouldShowLoadingView = true
    private var indexPathsNeededImageUpdate = [NSIndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTo3DTouch()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(SmallUserCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeUserCollectionViewCell.self, type: .Cell)
        collectionView.emptyDataSetSource = self
        viewModel.delegate = self
        self.title = viewModel.title
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.clearViewModelIfNeeded()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadInitialItems()
        AnalyticsManager.trackScreen(.FolloweesView)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellData = viewModel.followeeCollectionViewCellViewData(indexPath)

        indexPathsNeededImageUpdate.append(indexPath)

        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallUserCollectionViewCell.self,
                    forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            cell.avatarView.imageView.loadImageFromURL(cellData.avatarURL)
            cell.nameLabel.text = cellData.name
            cell.numberOfShotsLabel.text = cellData.numberOfShots
            if cellData.shotsImagesURLs?.count > 0 {
                cell.firstShotImageView.loadImageFromURL(cellData.shotsImagesURLs![0])
                cell.secondShotImageView.loadImageFromURL(cellData.shotsImagesURLs![1])
                cell.thirdShotImageView.loadImageFromURL(cellData.shotsImagesURLs![2])
                cell.fourthShotImageView.loadImageFromURL(cellData.shotsImagesURLs![3])
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(LargeUserCollectionViewCell.self,
                    forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            cell.avatarView.imageView.loadImageFromURL(cellData.avatarURL)
            cell.nameLabel.text = cellData.name
            cell.numberOfShotsLabel.text = cellData.numberOfShots
            if let shotImage = cellData.firstShotImage {

                let imageLoadingCompletion: UIImage -> Void = { [weak self] image in

                    guard let certainSelf = self
                            where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else { return }

                    cell.shotImageView.image = image
                }
                LazyImageProvider.lazyLoadImageFromURLs(
                    (shotImage.teaserURL, isCurrentLayoutOneColumn ? shotImage.normalURL : nil, nil),
                    teaserImageCompletion: imageLoadingCompletion,
                    normalImageCompletion: imageLoadingCompletion
                )
            }
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell,
                                 forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount - 1 {
            viewModel.downloadItemsForNextPage()
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let profileViewController = ProfileViewController(user: viewModel.followees[indexPath.item])
        profileViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell,
                                 forItemAtIndexPath indexPath: NSIndexPath) {
        if let index = indexPathsNeededImageUpdate.indexOf(indexPath) {
            indexPathsNeededImageUpdate.removeAtIndex(index)
        }
    }
    
    // Mark: Configuration
    
    func registerTo3DTouch() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
}

extension FolloweesCollectionViewController: BaseCollectionViewViewModelDelegate {

    func viewModelDidLoadInitialItems() {
        shouldShowLoadingView = false
        collectionView?.reloadData()
    }

    func viewModelDidFailToLoadInitialItems(error: ErrorType) {
        self.shouldShowLoadingView = false
        collectionView?.reloadData()

        if viewModel.followees.isEmpty {
            let alert = UIAlertController.generalError()
            tabBarController?.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func viewModelDidFailToLoadItems(error: ErrorType) {
        let alert = UIAlertController.unableToDownloadItems()
        tabBarController?.presentViewController(alert, animated: true, completion: nil)
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

extension FolloweesCollectionViewController: DZNEmptyDataSetSource {

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {

        if shouldShowLoadingView {
            let loadingView = EmptyDataSetLoadingView.newAutoLayoutView()
            loadingView.startAnimating()
            return loadingView
        } else {
            let emptyDataSetView = EmptyDataSetView.newAutoLayoutView()
            emptyDataSetView.setDescriptionText(
                firstLocalizedString: NSLocalizedString("FolloweesCollectionView.EmptyData.FirstLocalizedString",
                        comment: "FolloweesCollectionView, empty data set view"),
                attachmentImage: UIImage(named: "ic-following-emptystate"),
                imageOffset: CGPoint(x: 0, y: -3),
                lastLocalizedString: NSLocalizedString("FolloweesCollectionView.EmptyData.LastLocalizedString",
                        comment: "FolloweesCollectionView, empty data set view")
            )
            return emptyDataSetView
        }
    }
}

// MARK: UIViewControllerPreviewingDelegate

extension FolloweesCollectionViewController: UIViewControllerPreviewingDelegate {
    
    /// Create a previewing view controller to be shown at "Peek".
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        
        if let collectionView = collectionView where
            collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? SmallUserCollectionViewCell else { return nil }
            previewingContext.sourceRect = cell.shotsView.convertRect(cell.shotsView.bounds, toView: view)
        } else {
            guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? LargeUserCollectionViewCell else { return nil }
            previewingContext.sourceRect = cell.shotsView.convertRect(cell.shotsView.bounds, toView: view)
        }
        
        let profileViewController = ProfileViewController(user: viewModel.followees[indexPath.item])
        profileViewController.hidesBottomBarWhenPushed = true
        
        return profileViewController
    }
    
    /// Present the view controller for the "Pop" action.
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit,
                                                 animated: false)
    }
}
