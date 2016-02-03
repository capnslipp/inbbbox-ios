//
//  FolloweesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class FolloweesCollectionViewController: TwoLayoutsCollectionViewController {
    
    // MARK: - Lifecycle
    
    var followees = [Followee]()
    let connectionsProvider = ConnectionsProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(FolloweeCollectionViewCell.self, type: .Cell)
        title = NSLocalizedString("Following", comment:"")
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
        let cell = collectionView.dequeueReusableClass(FolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.followee = followees[indexPath.row]
        //NGRTemp: download shots for users
        cell.shotImagesUrlStrings = ["https://d13yacurqjgara.cloudfront.net/users/1065997/screenshots/2500813/3_1x.png","https://d13yacurqjgara.cloudfront.net/users/691242/screenshots/2500811/cy_logo_challenge_004_dbl_1x.png","https://d13yacurqjgara.cloudfront.net/users/721601/screenshots/2500809/mouse_1x.png","https://d13yacurqjgara.cloudfront.net/users/159102/screenshots/2500807/floating_dribbble_1x.jpg"]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present followee details view controller
    }
}
