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
    private let bucketsProvider = BucketsProvider()
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
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
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
                self.collectionView?.reloadData()
            }
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
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
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
        return collectionView.dequeueReusableClass(BucketCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
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
