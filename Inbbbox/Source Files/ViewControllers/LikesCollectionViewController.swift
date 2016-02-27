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
    
    private var likedShots = [ShotType]()
    private let shotsProvider = ShotsProvider()
    private var isUserLogged: Bool {
        return UserStorage.currentUser != nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Likes", comment: "")
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        collectionView.registerClass(LikeCollectionViewCell.self, type: .Cell)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isUserLogged ? downloadInitialShots() : loadLocallyStoredShots()
    }
    // MARK: Loading shots
    
    func loadLocallyStoredShots() {
        // NGRTodo: Implement this
    }
    
    func downloadInitialShots() {
        firstly {
            shotsProvider.provideLikedShotsForUser(UserStorage.currentUser!)
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
            shotsProvider.nextPage()
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
        if indexPath.row == likedShots.count - 1 && isUserLogged {
            downloadShotsForNextPage()
        }
        let cell = collectionView.dequeueReusableClass(LikeCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.image = nil
        let shot = likedShots[indexPath.item]
        cell.shotImageView.loadImageFromURL(shot.shotImage.normalURL)
        cell.gifLabel.hidden = !shot.animated
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // NGRTodo: present like details view controller
    }
}
