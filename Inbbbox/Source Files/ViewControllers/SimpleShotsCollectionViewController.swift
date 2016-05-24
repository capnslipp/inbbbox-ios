//
//  SimpleShotsCollectionViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 13/04/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import ZFDragableModalTransition
import DZNEmptyDataSet

class SimpleShotsCollectionViewController: TwoLayoutsCollectionViewController {

    var viewModel: SimpleShotsViewModel?
    var modalTransitionAnimator: ZFModalTransitionAnimator?

    private var shouldShowLoadingView = true

    private var indexPathsNeededImageUpdate = [NSIndexPath]()

}

// MARK: Lifecycle

extension SimpleShotsCollectionViewController {

    /// Use this `init` to display shots from given bucket.
    ///
    /// - parameter bucket: Bucket to display shots for.
    convenience init(bucket: BucketType) {
        self.init(oneColumnLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio,
                twoColumnsLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio)
        self.viewModel = BucketContentViewModel(bucket: bucket)
    }

    /// Use this `init` to display liked shots.
    convenience init() {
        self.init(oneColumnLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio,
            twoColumnsLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio)
        self.viewModel = LikesViewModel()
    }
}

// MARK: UIViewController

extension SimpleShotsCollectionViewController {

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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.clearViewModelIfNeeded()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.downloadInitialItems()
    }
}

// MARK: UICollectionViewDataSource

extension SimpleShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.itemsCount
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(SimpleShotCollectionViewCell.self, forIndexPath: indexPath,
                type: .Cell)
        cell.shotImageView.image = nil
        let cellData = viewModel!.shotCollectionViewCellViewData(indexPath)

        indexPathsNeededImageUpdate.append(indexPath)
        lazyLoadImage(cellData.shotImage, forCell: cell, atIndexPath: indexPath)

        cell.gifLabel.hidden = !cellData.animated
        return cell
    }

}

// MARK: UICollectionViewDelegate

extension SimpleShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell,
            forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel!.itemsCount - 1 {
            viewModel?.downloadItemsForNextPage()
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        guard let viewModel = viewModel else {
            return
        }

        let shotDetailsViewController = ShotDetailsViewController(shot: viewModel.shots[indexPath.item])

        modalTransitionAnimator =
                CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)

        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom

        tabBarController?.presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell,
                                 forItemAtIndexPath indexPath: NSIndexPath) {
        if let index = indexPathsNeededImageUpdate.indexOf(indexPath) {
            indexPathsNeededImageUpdate.removeAtIndex(index)
        }
    }
}

extension SimpleShotsCollectionViewController: BaseCollectionViewViewModelDelegate {

    func viewModelDidLoadInitialItems() {
        shouldShowLoadingView = false
        collectionView?.reloadData()
    }

    func viewModelDidFailToLoadInitialItems(error: ErrorType) {
        self.shouldShowLoadingView = false
        collectionView?.reloadData()

        if let viewModel = viewModel where viewModel.shots.isEmpty {
            let alert = UIAlertController.generalErrorAlertController()
            tabBarController?.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func viewModelDidFailToLoadItems(error: ErrorType) {
        let alert = UIAlertController.unableToDownloadItemsAlertController()
        tabBarController?.presentViewController(alert, animated: true, completion: nil)
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

extension SimpleShotsCollectionViewController: DZNEmptyDataSetSource {

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {

        guard let viewModel = viewModel else { return UIView() }

        if shouldShowLoadingView {
            let loadingView = EmptyDataSetLoadingView.newAutoLayoutView()
            loadingView.startAnimating()
            return loadingView
        } else {
            let emptyDataSetView = EmptyDataSetView.newAutoLayoutView()
            let descriptionAttributes = viewModel.emptyCollectionDescriptionAttributes()
            emptyDataSetView.setDescriptionText(
                firstLocalizedString: descriptionAttributes.firstLocalizedString,
                attachmentImage: UIImage(named: descriptionAttributes.attachmentImageName),
                imageOffset: descriptionAttributes.imageOffset,
                lastLocalizedString: descriptionAttributes.lastLocalizedString
            )
            return emptyDataSetView
        }
    }
}

// MARK: Lazy loading of image

private extension SimpleShotsCollectionViewController {

    func lazyLoadImage(shotImage: ShotImageType, forCell cell: SimpleShotCollectionViewCell,
            atIndexPath indexPath: NSIndexPath) {
        let imageLoadingCompletion: UIImage -> Void = { [weak self] image in

            guard let certainSelf = self where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else {
                return
            }

            cell.shotImageView.image = image
        }
        LazyImageProvider.lazyLoadImageFromURLs(
            (shotImage.teaserURL, isCurrentLayoutOneColumn ? shotImage.normalURL : nil, nil),
            teaserImageCompletion: imageLoadingCompletion,
            normalImageCompletion: imageLoadingCompletion
        )
    }
}
