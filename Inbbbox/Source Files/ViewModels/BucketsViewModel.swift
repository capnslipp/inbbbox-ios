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
    private var buckets = [BucketType]()
    private var bucketsIndexedShots = [Int : [ShotType]]()
    private let bucketsProvider = BucketsProvider()
    private let shotsProvider = ShotsProvider()
    
    var itemsCount: Int {
        return buckets.count
    }
    
    func downloadInitialItems() {
        firstly {
            bucketsProvider.provideMyBuckets()
        }.then { buckets -> Void in
            if let buckets = buckets {
                self.buckets = buckets
                self.downloadShots(buckets)
            }
            self.delegate?.viewModelDidLoadInitialItems(self)
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadItemsForNextPage() {
        guard UserStorage.currentUser != nil else {
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
            print(error)
        }
    }
    
    private func downloadShots(buckets: [BucketType]) {
        for bucket in buckets {
            firstly {
                shotsProvider.provideShotsForBucket(bucket)
            }.then { shots -> Void in
                var indexOfBucket: Int?
                for (index, item) in self.buckets.enumerate(){
                    if item.identifier == bucket.identifier {
                        indexOfBucket = index
                        break
                    }
                }
                guard let index = indexOfBucket else {
                    return
                }
                if let shots = shots {
                    self.bucketsIndexedShots[index] = shots
                } else {
                    self.bucketsIndexedShots[index] = [ShotType]()
                }
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.delegate?.viewModel(self, didLoadShotsForItemAtIndexPath: indexPath)
            }.error { error in
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }
    
    func bucketCollectionViewCellViewData(indexPath: NSIndexPath) -> BucketCollectionViewCellViewData {
        return BucketCollectionViewCellViewData(bucket: buckets[indexPath.row], shots: bucketsIndexedShots[indexPath.row])
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
