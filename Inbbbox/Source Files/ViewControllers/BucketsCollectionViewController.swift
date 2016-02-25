//
//  BucketsCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class BucketsCollectionViewController: UICollectionViewController, BucketsViewModelDelegate {

    private let viewModel = BucketsViewModel()

    // MARK: - Lifecycle

    convenience init() {
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = BucketCollectionViewCell.heightToWidthRatio;
        self.init(collectionViewLayout: flowLayout)
        title = viewModel.title
        viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(BucketCollectionViewCell.self, type: .Cell)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadInitialBuckets()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bucketsCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel.bucketsCount - 1 {
            viewModel.downloadBucketsForNextPage()
        }
        let cell = collectionView.dequeueReusableClass(BucketCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.clearImages()
        let cellData = viewModel.bucketCollectionViewCellViewData(indexPath)
        cell.nameLabel.text = cellData.name
        cell.numberOfShotsLabel.text = cellData.numberOfShots
        if let shotImagesURLs = cellData.shotsImagesURLs {
            cell.firstShotImageView.loadImageFromURL(shotImagesURLs[0])
            cell.secondShotImageView.loadImageFromURL(shotImagesURLs[1])
            cell.thirdShotImageView.loadImageFromURL(shotImagesURLs[2])
            cell.fourthShotImageView.loadImageFromURL(shotImagesURLs[3])
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present bucket details view controller
    }
    
    // MARK: Buckets View Model Delegate
    
    func bucketsViewModelDidLoadInitialBuckets(viewModel: BucketsViewModel) {
        collectionView?.reloadData()
    }
    
    func bucketsViewModel(viewModel: BucketsViewModel, didLoadBucketsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }
    
    func bucketsViewModel(viewModel: BucketsViewModel, didLoadShotsForBucketAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}
