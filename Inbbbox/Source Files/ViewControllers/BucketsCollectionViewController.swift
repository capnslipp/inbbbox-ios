//
//  BucketsCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class BucketsCollectionViewController: UICollectionViewController {

    private var buckets = [Bucket]()
    private var bucketsShots = [Bucket : [Shot]]()
    private let bucketsProvider = BucketsProvider()
    private let shotsProvider = ShotsProvider()
    private var isUserLogged: Bool {
        get {
            return UserStorage.currentUser != nil
        }
    }
    
    // MARK: - Lifecycle

    convenience init() {
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = BucketCollectionViewCell.heightToWidthRatio;
        self.init(collectionViewLayout: flowLayout)
        title = NSLocalizedString("Buckets", comment:"")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtons()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(BucketCollectionViewCell.self, type: .Cell)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isUserLogged ? downloadInitialBuckets() : loadLocallyStoredBuckets()
    }
    
    // MARK: Loading buckets
    
    func loadLocallyStoredBuckets() {
        // NGRTodo: Implement this
    }
    
    func downloadInitialBuckets() {
        firstly {
            self.bucketsProvider.provideMyBuckets()
        }.then { buckets -> Void in
            if let buckets = buckets {
                self.buckets = buckets
                self.downloadShots(buckets)
            }
            self.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadBucketsForNextPage() {
        firstly {
            self.bucketsProvider.nextPage()
        }.then { buckets -> Void in
            if let buckets = buckets where buckets.count > 0 {
                let indexes = buckets.enumerate().map { index, _ in
                    return index + self.buckets.count
                }
                self.buckets.appendContentsOf(buckets)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow:($0), inSection: 0)
                }
                self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                self.downloadShots(buckets)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    //MARK: Downloading shots
    
    func downloadShots(buckets: [Bucket]) {
        for bucket in buckets {
            firstly {
                self.shotsProvider.provideShotsForBucket(bucket)
            }.then { shots -> Void in
                if let shots = shots {
                    self.bucketsShots[bucket] = shots
                } else {
                    self.bucketsShots[bucket] = [Shot]()
                }
                guard let index = self.buckets.indexOf(bucket) else {
                    return
                }
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.collectionView?.reloadItemsAtIndexPaths([indexPath])  
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buckets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == buckets.count - 1 && isUserLogged {
            downloadBucketsForNextPage()
        }
        let cell = collectionView.dequeueReusableClass(BucketCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        let bucket = buckets[indexPath.row]
        presentBucketForCell(bucket, cell: cell)
        if let bucketShots = bucketsShots[bucket] {
            let shotImagesUrls = bucketShots.map { $0.image.normalURL }
            presentShotsImagesForCell(shotImagesUrls, cell: cell)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present bucket details view controller
    }

    // MARK: Configuration
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add New", comment: ""), style: .Plain, target: self, action: "didTapAddNewBucketButton:")
    }

    // MARK: Actions:

    func didTapAddNewBucketButton(_: UIBarButtonItem) {
        // NGRTodo: Implement this
    }
}

// MARK - Cells data filling

private extension BucketsCollectionViewController {
        
    func presentBucketForCell(bucket: Bucket, cell: BucketCollectionViewCell) {
        cell.nameLabel.text = bucket.name
        cell.numberOfShotsLabel.text = bucket.shotsCount == 1 ? "\(bucket.shotsCount) shot" : "\(bucket.shotsCount) shots"
    }
        
    func presentShotsImagesForCell(shotImagesURLs: [NSURL], cell: BucketCollectionViewCell) {
        guard shotImagesURLs.count > 0 else {
            return
        }
        let repeatedShotURLs = Array(Array(Array(count: 4, repeatedValue: shotImagesURLs).flatten())[0...3])
        cell.firstShotImageView.loadImageFromURL(repeatedShotURLs[0])
        cell.secondShotImageView.loadImageFromURL(repeatedShotURLs[1])
        cell.thirdShotImageView.loadImageFromURL(repeatedShotURLs[2])
        cell.fourthShotImageView.loadImageFromURL(repeatedShotURLs[3])
    }
}
