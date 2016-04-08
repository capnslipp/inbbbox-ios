//
//  BucketsViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 24.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit


class BucketsViewModel: BaseCollectionViewViewModel {
    
    var delegate: BaseCollectionViewViewModelDelegate?
    let title = NSLocalizedString("Buckets", comment:"")
    var buckets = [BucketType]()
    var bucketsIndexedShots = [Int : [ShotType]]()
    private let bucketsProvider = BucketsProvider()
    private let bucketsRequester = BucketsRequester()
    private let shotsProvider = ShotsProvider()
    private var userMode: UserMode
    
    var itemsCount: Int {
        return buckets.count
    }
    
    init() {
        userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser
    }
    
    func downloadInitialItems() {
        firstly {
            bucketsProvider.provideMyBuckets()
        }.then { buckets -> Void in
            var bucketsShouldBeReloaded = true
            if let buckets = buckets {
                if buckets == self.buckets && buckets.count != 0 {
                    bucketsShouldBeReloaded = false
                }
                self.buckets = buckets
                self.downloadShots(buckets)
            }
            if bucketsShouldBeReloaded {
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error { error in
            self.delegate?.viewModelDidFailToLoadInitialItems(error)
        }
    }
    
    func downloadItemsForNextPage() {
        guard UserStorage.isUserSignedIn else {
            return
        }
        firstly {
            bucketsProvider.nextPage()
        }.then { buckets -> Void in
            if let buckets = buckets where buckets.count > 0 {
                let indexes = buckets.enumerate().map { index, _ in
                    return index + self.buckets.count
                }
                self.buckets.appendContentsOf(buckets)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow:($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
                self.downloadShots(buckets)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
        }
    }
    
    func downloadShots(buckets: [BucketType]) {
        for bucket in buckets {
            firstly {
                shotsProvider.provideShotsForBucket(bucket)
            }.then { shots -> Void in
                var bucketShotsShouldBeReloaded = true
                var indexOfBucket: Int?
                for (index, item) in self.buckets.enumerate(){
                    if item.identifier == bucket.identifier {
                        indexOfBucket = index
                        break
                    }
                }
                guard let index = indexOfBucket else { return }
                
                if let oldShots = self.bucketsIndexedShots[index], newShots = shots {
                     bucketShotsShouldBeReloaded = oldShots != newShots
                }
                
                if let shots = shots {
                    self.bucketsIndexedShots[index] = shots
                } else {
                    self.bucketsIndexedShots[index] = [ShotType]()
                }
                
                if bucketShotsShouldBeReloaded {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.delegate?.viewModel(self, didLoadShotsForItemAtIndexPath: indexPath)
                }
            }.error { error in
                // NGRTemp: Need mockups for error message view
            }
        }
    }
    
    func createBucket(name: String, description: NSAttributedString? = nil) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            firstly {
                bucketsRequester.postBucket(name, description: description)
            }.then { bucket in
                self.buckets.append(bucket)
            }.then(fulfill).error(reject)
        }
    }
    
    func bucketCollectionViewCellViewData(indexPath: NSIndexPath) -> BucketCollectionViewCellViewData {
        return BucketCollectionViewCellViewData(bucket: buckets[indexPath.row], shots: bucketsIndexedShots[indexPath.row])
    }
    
    func clearViewModelIfNeeded() {
        let currentUserMode = UserStorage.isUserSignedIn ? UserMode.LoggedUser : .DemoUser
        if userMode != currentUserMode {
            buckets = []
            userMode = currentUserMode
            delegate?.viewModelDidLoadInitialItems()
        }
    }
}

extension BucketsViewModel {
    
    struct BucketCollectionViewCellViewData {
        let name: String
        let numberOfShots: String
        let shotsImagesURLs: [NSURL]?
        
        init(bucket: BucketType, shots: [ShotType]?) {
            self.name = bucket.name
            self.numberOfShots = bucket.shotsCount == 1 ? "\(bucket.shotsCount) shot" : "\(bucket.shotsCount) shots"
            if let shots = shots where shots.count > 0 {
                let allShotsImagesURLs = shots.map { $0.shotImage.normalURL }
                self.shotsImagesURLs =  Array(Array(Array(count: 4, repeatedValue: allShotsImagesURLs).flatten())[0...3])
            } else {
                self.shotsImagesURLs = nil
            }
        }
    }
}
