//
//  LikesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class LikesCollectionViewController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    // NGRTemp: temporary implementation - Downloading shots instead of liked shots.
    // Query and func in provider needs to be implemented
    // Maybe we should download liked shots earlier?
    
    var likedShots = [Shot]()
    let shotsProvider = ShotsProvider()
    
    var oneColumnLayoutButton: UIBarButtonItem?
    var twoColumnsLayoutButton: UIBarButtonItem?
    
    convenience init() {
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = LikeCollectionViewCell.heightToWidthRatio
        self.init(collectionViewLayout: flowLayout)
        title = NSLocalizedString("Likes", comment:"")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(LikeCollectionViewCell.self, type: .Cell)
        setupBarButtons()
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
        
            }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        firstly {
            self.shotsProvider.provideShots()
        }.then { shots -> Void in
            self.likedShots = shots
            self.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedShots.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(LikeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
         // NGRTemp: temporary implementation - image should probably be downloaded earlier
        let shot = likedShots[indexPath.item]
        cell.shotImageView.loadImageFromURL(shot.image.normalURL)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present like details view controller
    }
    
    // MARK: Configuration
    
    func setupBarButtons() {
        // NGRTodo: set images instead of title
        oneColumnLayoutButton = UIBarButtonItem(title: "1", style: .Plain, target: self, action: "didTapOneColumnLayoutButton:")
        twoColumnsLayoutButton = UIBarButtonItem(title: "2", style: .Plain, target: self, action: "didTapTwoColumnsLayoutButton:")
        if let firstBarButton = oneColumnLayoutButton, secondBarButton = twoColumnsLayoutButton {
            navigationItem.rightBarButtonItems = [firstBarButton, secondBarButton]
        }
    }
    
    func updateBarButtons(layout: UICollectionViewLayout) {
        if layout.isKindOfClass(OneColumnCollectionViewFlowLayout) {
            oneColumnLayoutButton?.enabled = false
            twoColumnsLayoutButton?.enabled = true
        } else {
            oneColumnLayoutButton?.enabled = true
            twoColumnsLayoutButton?.enabled = false
        }
    }
    
    // MARK: Actions:
    
    func didTapOneColumnLayoutButton(_: UIBarButtonItem) {
        guard let collectionView = collectionView else {
            return
        }
        let flowLayout = OneColumnCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = LikeCollectionViewCell.heightToWidthRatio
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    func didTapTwoColumnsLayoutButton(_: UIBarButtonItem) {
        guard let collectionView = collectionView else {
            return
        }
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = LikeCollectionViewCell.heightToWidthRatio
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        updateBarButtons(collectionView.collectionViewLayout)
    }
}
