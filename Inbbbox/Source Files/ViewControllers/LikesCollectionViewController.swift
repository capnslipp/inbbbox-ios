//
//  LikesCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class LikesCollectionViewController: TwoLayoutsCollectionViewController {
    
    // MARK: - Lifecycle
    
    // NGRTemp: temporary implementation - Downloading shots instead of liked shots.
    // Query and func in provider needs to be implemented
    // Maybe we should download liked shots earlier?
    
    var likedShots = [Shot]()
    let shotsProvider = ShotsProvider()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Likes", comment: "")
        guard let collectionView = collectionView else {
            return
        }
        collectionView.registerClass(LikeCollectionViewCell.self, type: .Cell)
        downloadInitialShots()
    }
    
    // MARK: Downloading
    
    func downloadInitialShots() {
        guard let user = UserStorage.currentUser else {
            return
        }
        firstly {
            self.shotsProvider.provideLikedShotsForUser(user)
        }.then { shots -> Void in
            if let shots = shots {
                self.likedShots = shots
                self.collectionView?.reloadData()
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadShotsForNextPage() {
         firstly {
            self.shotsProvider.nextPage()
        }.then { shots -> Void in
            if let shots = shots where shots.count > 0 {
                let indexes = shots.enumerate().map { index, _ in
                    return index + self.likedShots.count
                }
                self.likedShots.appendContentsOf(shots)
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
        return likedShots.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == likedShots.count - 1 {
            downloadShotsForNextPage()
        }
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
}
