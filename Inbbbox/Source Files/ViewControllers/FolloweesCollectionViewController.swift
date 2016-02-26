//
//  FolloweesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class FolloweesCollectionViewController: TwoLayoutsCollectionViewController, BaseCollectionViewViewModelDelegate {
    
    // MARK: - Lifecycle
    
    private let viewModel = FolloweesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(SmallFolloweeCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeFolloweeCollectionViewCell.self, type: .Cell)
        viewModel.delegate = self
        self.title = viewModel.title
        viewModel.downloadInitialItems()
    }
 
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel.itemsCount - 1 {
            viewModel.downloadItemsForNextPage()
        }
        let cellData = viewModel.followeeCollectionViewCellViewData(indexPath)
        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            configureCell(cellData, cell: cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(LargeFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            configureCell(cellData, cell: cell)
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present followee details view controller
    }
    
    // MARK: Base Collection View View Model Delegate
    
    func viewModelDidLoadInitialItems(viewModel: BaseCollectionViewViewModel) {
        collectionView?.reloadData()
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

// MARK - Cells data filling

private extension FolloweesCollectionViewController {
    
    func configureCell<T: BaseInfoShotsCollectionViewCell where T: AvatarSettable>(data: FolloweeCollectionViewCellViewData, cell: T) {
        if let avatarString = data.avatarString {
            cell.avatarView.imageView.loadImageFromURLString(avatarString)
        } else {
            cell.avatarView.imageView.image = nil
        }
        cell.nameLabel.text = data.name
        cell.numberOfShotsLabel.text = data.numberOfShots
        if cell.isKindOfClass(LargeFolloweeCollectionViewCell) && (data.shotsImagesURLs?.count > 0) {
            let cell = cell as! LargeFolloweeCollectionViewCell
            cell.shotImageView.loadImageFromURL(data.shotsImagesURLs!.first!)
        } else if cell.isKindOfClass(SmallFolloweeCollectionViewCell) {
            if cell.isKindOfClass(SmallFolloweeCollectionViewCell) && (data.shotsImagesURLs?.count > 0) {
                let cell = cell as! SmallFolloweeCollectionViewCell
                cell.firstShotImageView.loadImageFromURL(data.shotsImagesURLs![0])
                cell.secondShotImageView.loadImageFromURL(data.shotsImagesURLs![1])
                cell.thirdShotImageView.loadImageFromURL(data.shotsImagesURLs![2])
                cell.fourthShotImageView.loadImageFromURL(data.shotsImagesURLs![3])
            }
        }
    }
}
