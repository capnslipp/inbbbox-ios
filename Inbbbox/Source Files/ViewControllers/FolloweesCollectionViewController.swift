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
    
    private var followees = [Followee]()
    private var followeesShots = [Followee : [Shot]]()
    private let connectionsProvider = ConnectionsProvider()
    private let shotsProvider = ShotsProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(SmallFolloweeCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeFolloweeCollectionViewCell.self, type: .Cell)
        title = NSLocalizedString("Following", comment:"")
        downloadInitialFollowees()
    }
    
    // MARK: Downloading
    
    func downloadInitialFollowees() {
        firstly {
            self.connectionsProvider.provideMyFollowees()
        }.then { followees -> Void in
            if let followees = followees {
                self.followees.appendContentsOf(followees)
                self.downloadShots(followees)
            }
            self.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadFolloweesForNextPage() {
        // NGRTemp: Display only 30 followers on screen to avoid
        // exceeded number of requests (Dribbble allows 60 request per minute).
        // Needs to be changed.
        let isNextPageAvailable = self.followees.count < 30
        if isNextPageAvailable {
            firstly {
                self.connectionsProvider.nextPage()
            }.then { followees -> Void in
                if let followees = followees where followees.count > 0 {
                    let indexes = followees.enumerate().map { index, _ in
                        return index + self.followees.count
                    }
                    self.followees.appendContentsOf(followees)
                    let indexPaths = indexes.map {
                        NSIndexPath(forRow:($0), inSection: 0)
                    }
                    self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                    self.downloadShots(followees)
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
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
                guard let index = self.followees.indexOf(followee) else {
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
        return followees.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == followees.count - 1 {
            downloadFolloweesForNextPage()
        }
        if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
            let cell = collectionView.dequeueReusableClass(SmallFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            let followee = followees[indexPath.row]
            presentFoloweeForCell(followee, cell: cell)
            if let followeeShots = followeesShots[followee] {
                let shotImagesUrls = followeeShots.map { $0.image.normalURL }
                presentSmallShotsImagesForCell(shotImagesUrls, cell: cell)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(LargeFolloweeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            let followee = followees[indexPath.row]
            presentFoloweeForCell(followee, cell: cell)
            let shotImageUrl = followeesShots[followee]?.first?.image.normalURL
            presentLargeShotImageForCell(shotImageUrl, cell: cell)
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
    
    func presentFoloweeForCell<T: BaseInfoShotsCollectionViewCell where T: AvatarSettable>(followee: Followee, cell: T) {
        if let avatarString = followee.avatarString {
            cell.avatarView.imageView.loadImageFromURLString(avatarString)
        } else {
            cell.avatarView.imageView.image = nil
        }
        cell.userNameLabel.text = followee.name
        cell.numberOfShotsLabel.text = "\(followee.shotsCount) shots"
    }
    
    func presentLargeShotImageForCell(shotImageUrl: NSURL?, cell: LargeFolloweeCollectionViewCell) {
        if let shotImageUrl = shotImageUrl {
            cell.shotImageView.loadImageFromURL(shotImageUrl)
        } else {
            cell.shotImageView.image = nil
        }
    }
    
    func presentSmallShotsImagesForCell(shotImagesUrls: [NSURL], cell: SmallFolloweeCollectionViewCell) {
        switch shotImagesUrls.count {
        case 0:
            cell.firstShotImageView.image = nil
            cell.secondShotImageView.image = nil
            cell.thirdShotImageView.image = nil
            cell.fourthShotImageView.image = nil
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
