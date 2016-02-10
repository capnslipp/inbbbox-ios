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
    
    private var followees = NSMutableOrderedSet()
    private var followeesShots = [Followee : [Shot]]()
    private let connectionsProvider = ConnectionsProvider()
    private let shotsProvider = ShotsProvider()
    private var isNextPageAvailable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(SmallFolloweeCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeFolloweeCollectionViewCell.self, type: .Cell)
        title = NSLocalizedString("Following", comment:"")
        downloadFollowees()
    }
    
    // MARK: Downloading
    
    func downloadFollowees() {
        firstly {
            self.connectionsProvider.provideMyFollowees()
            }.then { followees -> Void in
                if let followees = followees {
                    self.followees.addObjectsFromArray(followees)
                    self.downloadShots(followees)
                }
                self.collectionView?.reloadData()
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
        }
    }
    
    func downloadFolloweesForNextPage() {
        if isNextPageAvailable {
            firstly {
                self.connectionsProvider.nextPage()
                }.then { followees -> Void in
                    if let followees = followees {
                        if followees.count > 0 {
                            self.followees.addObjectsFromArray(followees)
                            let indexPaths = followees.map({NSIndexPath(forRow: self.followees.indexOfObject($0), inSection: 0)})
                            self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                            self.downloadShots(followees)
                        } else {
                            self.isNextPageAvailable = false
                        }
                    } else {
                        self.isNextPageAvailable = false
                    }
                }.error { error in
                    // NGRTemp: Need mockups for error message view
                    print(error)
                    self.isNextPageAvailable = false
            }
        }
    }
    
    func downloadShots(followees: [Followee]) {
        for followee in followees {
            firstly {
                self.shotsProvider.provideShotsForUser(followee)
                }.then { shots -> Void in
                if let shots = shots {
                        self.followeesShots[followee] = shots
                    } else {
                        self.followeesShots[followee] = [Shot]()
                    }
                    let indexPath = NSIndexPath(forRow: self.followees.indexOfObject(followee), inSection: 0)
                    self.collectionView?.reloadItemsAtIndexPaths([indexPath])
                }.error { error in
                    // NGRTemp: Need mockups for error message view
                    print(error)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followees.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == followees.count - 1 {
            downloadFolloweesForNextPage()
        }
        
        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            let followee = followees[indexPath.row] as! Followee
            presentFoloweeForCell(followee, cell: cell)
            if let followeeShots = followeesShots[followee] {
                let shotImagesUrls = followeeShots.map({ $0.image.normalURL })
                presentSmallShotsImagesForCell(shotImagesUrls, cell: cell)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(LargeFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let followee = followees[indexPath.row] as! Followee
            presentFoloweeForCell(followee, cell: cell)
            if let shotImageUrl = followeesShots[followee]?.first?.image.normalURL {
                presentLargeShotImageForCell(shotImageUrl, cell: cell)
            }
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
    
    func presentLargeShotImageForCell(shotImageUrl: NSURL, cell: LargeFolloweeCollectionViewCell) {
        cell.shotImageView.loadImageFromURL(shotImageUrl)
    }
    
    func presentSmallShotsImagesForCell(shotImagesUrls: [NSURL], cell: SmallFolloweeCollectionViewCell) {
        switch shotImagesUrls.count {
        case 0:
            return
        case 1:
            cell.firstShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.secondShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.thirdShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.fourthShotImageView.loadImageFromURL(shotImagesUrls[0])
        case 2:
            cell.firstShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.secondShotImageView.loadImageFromURL(shotImagesUrls[1])
            cell.thirdShotImageView.loadImageFromURL(shotImagesUrls[1])
            cell.fourthShotImageView.loadImageFromURL(shotImagesUrls[0])
        case 3:
            cell.firstShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.secondShotImageView.loadImageFromURL(shotImagesUrls[1])
            cell.thirdShotImageView.loadImageFromURL(shotImagesUrls[2])
            cell.fourthShotImageView.loadImageFromURL(shotImagesUrls[0])
        default:
            cell.firstShotImageView.loadImageFromURL(shotImagesUrls[0])
            cell.secondShotImageView.loadImageFromURL(shotImagesUrls[1])
            cell.thirdShotImageView.loadImageFromURL(shotImagesUrls[2])
            cell.fourthShotImageView.loadImageFromURL(shotImagesUrls[3])
        }
    }
}
