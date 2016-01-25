//
//  BucketsCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BucketsCollectionViewController: UICollectionViewController {

    // MARK: - Lifecycle
    
    // NGRTemp: temporary implementation - remove after adding real buckets
    var buckets = ["bucket1", "bucket2", "bucket3", "bucket4", "bucket5", "bucket6", "bucket7"];
    
    convenience init() {
        // NGRTemp: temporary implementation - set proper flow layout
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buckets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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
