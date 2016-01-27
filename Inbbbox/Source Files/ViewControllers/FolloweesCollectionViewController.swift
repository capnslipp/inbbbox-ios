//
//  FolloweesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class FolloweesCollectionViewController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    var followees = [User]()
    let connectionsProvider = ConnectionsProvider()
    
    var oneColumnLayoutButton: UIBarButtonItem?
    var twoColumnsLayoutButton: UIBarButtonItem?
    
    convenience init() {
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = FolloweeCollectionViewCell.heightToWidthRatio
        self.init(collectionViewLayout: flowLayout)
        title = NSLocalizedString("Following", comment:"")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(FolloweeCollectionViewCell.self, type: .Cell)
        setupBarButtons()
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //NGRTodo: use paging
        firstly {
            self.connectionsProvider.provideMyFollowees()
        }.then { followees -> Void in
            if let followees = followees {
                self.followees = followees
                self.collectionView?.reloadData()
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followees.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(FolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present followee details view controller
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
        flowLayout.itemHeightToWidthRatio = FolloweeCollectionViewCell.heightToWidthRatio
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    func didTapTwoColumnsLayoutButton(_: UIBarButtonItem) {
        guard let collectionView = collectionView else {
            return
        }
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = FolloweeCollectionViewCell.heightToWidthRatio
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        updateBarButtons(collectionView.collectionViewLayout)
    }
}
