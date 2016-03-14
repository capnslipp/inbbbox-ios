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

class FolloweesCollectionViewController: TwoLayoutsCollectionViewController, BaseCollectionViewViewModelDelegate, DZNEmptyDataSetSource {
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.clearViewModelIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadInitialItems()
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.trackScreen(.FolloweesViewScreenName)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellData = viewModel.followeeCollectionViewCellViewData(indexPath)
        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            if let avatarString = cellData.avatarString {
                cell.avatarView.imageView.loadImageFromURLString(avatarString)
            } else {
                cell.avatarView.imageView.image = nil
            }
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
            let cell = collectionView.dequeueReusableClass(LargeFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.clearImages()
            if let avatarString = cellData.avatarString {
                cell.avatarView.imageView.loadImageFromURLString(avatarString)
            } else {
                cell.avatarView.imageView.image = nil
            }
            cell.nameLabel.text = cellData.name
            cell.numberOfShotsLabel.text = cellData.numberOfShots
            if let imageURL = cellData.shotsImagesURLs?.first {
                cell.shotImageView.loadImageFromURL(imageURL)
            }
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount {
            viewModel.downloadItemsForNextPage()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let userDetailsViewController = UserDetailsViewController(user: viewModel.followees[indexPath.item])
        userDetailsViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
    
    // MARK: Base Collection View View Model Delegate
    
    func viewModelDidLoadInitialItems() {
        if self.viewModel.followees.count == 0 {
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
        let localizedString = NSLocalizedString("Follow   someone first!", comment: "")
        let attributedString = NSMutableAttributedString.emptyDataSetStyledString(localizedString)
        
        let textAttachment: NSTextAttachment = NSTextAttachment()
        
        textAttachment.image = UIImage(named: "ic-following-emptystate")
        if let image = textAttachment.image {
            textAttachment.bounds = CGRect(x: 0, y: -3, width: image.size.width, height: image.size.height)
        }
        
        let attributedStringWithImage: NSAttributedString = NSAttributedString(attachment: textAttachment)
        
        attributedString.replaceCharactersInRange(NSMakeRange(7, 1), withAttributedString: attributedStringWithImage)
        return attributedString
    }
    
    func spaceHeightForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func verticalOffsetForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return -40
    }
}
