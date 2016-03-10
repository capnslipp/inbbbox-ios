//
//  BucketsCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import DZNEmptyDataSet

class BucketsCollectionViewController: UICollectionViewController, BaseCollectionViewViewModelDelegate, DZNEmptyDataSetSource {

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
        setupBarButtons()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(BucketCollectionViewCell.self, type: .Cell)
        collectionView.emptyDataSetSource = self
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
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount {
            viewModel.downloadItemsForNextPage()
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present bucket details view controller
    }
    
    // MARK: Configuration
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add New", comment: ""), style: .Plain, target: self, action: "didTapAddNewBucketButton:")
    }
    
    // MARK: Actions:
    
    func didTapAddNewBucketButton(_: UIBarButtonItem) {
        let alert = UIAlertController.provideBucketNameAlertController { bucketName in
            
            firstly {
                self.viewModel.createBucket(bucketName)
            }.then { () -> Void in
                self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.viewModel.buckets.count-1, inSection: 0)])
            }.error { error in
                print(error)
            }
        }
        self.presentViewController(alert, animated: true, completion: nil)
        alert.view.tintColor = .pinkColor()
    }
    
    // MARK: Base Collection View View Model Delegate
    
    func viewModelDidLoadInitialItems() {
        if self.viewModel.buckets.count == 0 {
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
        let localizedString = NSLocalizedString("Add some shots\nto buckets   first", comment: "")
        let attributedString = NSMutableAttributedString.emptyDataSetStyledString(localizedString)
        
        let textAttachment: NSTextAttachment = NSTextAttachment()
        
        textAttachment.image = UIImage(named: "ic-bucket-emptystate")
        if let image = textAttachment.image {
            textAttachment.bounds = CGRect(x: 0, y: -4, width: image.size.width, height: image.size.height)
        }
        
        let attributedStringWithImage: NSAttributedString = NSAttributedString(attachment: textAttachment)
        
        attributedString.replaceCharactersInRange(NSMakeRange(26, 1), withAttributedString: attributedStringWithImage)
        return attributedString
    }
    
    func spaceHeightForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func verticalOffsetForEmptyDataSet(_: UIScrollView!) -> CGFloat {
        return -40
    }
}

