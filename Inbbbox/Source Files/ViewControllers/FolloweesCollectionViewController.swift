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
        collectionView.registerClass(SmallFolloweeCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeFolloweeCollectionViewCell.self, type: .Cell)
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
        
        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            let followee = followees[indexPath.row]
            //NGRTemp: download shots for users
            let shotImagesUrlStrings = ["https://d13yacurqjgara.cloudfront.net/users/1065997/screenshots/2500813/3_1x.png","https://d13yacurqjgara.cloudfront.net/users/691242/screenshots/2500811/cy_logo_challenge_004_dbl_1x.png","https://d13yacurqjgara.cloudfront.net/users/721601/screenshots/2500809/mouse_1x.png","https://d13yacurqjgara.cloudfront.net/users/159102/screenshots/2500807/floating_dribbble_1x.jpg"]
            presentFoloweeForCell(followee, cell: cell)
            presentSmallShotsImagesForCell(shotImagesUrlStrings, cell: cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(LargeFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            let followee = followees[indexPath.row]
            //NGRTemp: download shots for users
            let shotImageUrlString = "https://d13yacurqjgara.cloudfront.net/users/691242/screenshots/2500811/cy_logo_challenge_004_dbl_1x.png"
            presentFoloweeForCell(followee, cell: cell)
            presentLargeShotImageForCell(shotImageUrlString, cell: cell)
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present followee details view controller
    }
}

// MARK - Cells data filling

private extension FolloweesCollectionViewController {
    
    func presentFoloweeForCell(followee: Followee, cell: BaseFolloweeCollectionViewCell) {
        if let avatarString = followee.avatarString {
            cell.avatarView.imageView.loadImageFromURLString(avatarString)
        }
        cell.userNameLabel.text = followee.name
        cell.numberOfShotsLabel.text = "\(followee.shotsCount) shots"
    }
    
    func presentLargeShotImageForCell(shotImageUrlString: String, cell: LargeFolloweeCollectionViewCell) {
        cell.shotImageView.loadImageFromURLString(shotImageUrlString)
    }
    
    func presentSmallShotsImagesForCell(shotImagesUrlStrings: [String], cell: SmallFolloweeCollectionViewCell) {
        switch shotImagesUrlStrings.count {
        case 0:
            return
        case 1:
            cell.firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        case 2:
            cell.firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            cell.thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            cell.fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        case 3:
            cell.firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            cell.thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[2])
            cell.fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        default:
            cell.firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            cell.secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            cell.thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[2])
            cell.fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[3])
        }
    }
}
