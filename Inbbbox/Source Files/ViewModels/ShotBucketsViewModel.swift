//
//  ShotBucketsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 24/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class ShotBucketsViewModel {
    
    var itemsCount: Int {
        
        var counter = Int(0)

        counter += buckets.count
        
        switch shotBucketsViewControllerMode {
        case .AddToBucket:
            break
        case .RemoveFromBucket:
            counter += 2  // for "Remove From Selected Buckets" and gap before
        }
        return counter
    }
    
    var attributedShotTitleForHeader: NSAttributedString {
        return ShotDetailsFormatter.attributedStringForHeaderFromShot(shot)
    }
    
    var titleForHeader: String {
        switch shotBucketsViewControllerMode {
        case .AddToBucket:
            return NSLocalizedString("Add To Bucket", comment: "")
        case .RemoveFromBucket:
            return NSLocalizedString("Remove From Bucket", comment: "")
        }
    }
    
    let shot: ShotType
    let shotBucketsViewControllerMode: ShotBucketsViewControllerMode
    
    var bucketsProvider = APIBucketsProvider(page: 1, pagination: 100)
    var bucketsRequester = APIBucketsRequester()
    var shotsRequester = APIShotsRequester()
    
    private(set) var buckets = [BucketType]()
    private var selectedBucketsIndexes = [Int]()
    
    init(shot: ShotType, mode: ShotBucketsViewControllerMode) {
        self.shot = shot
        shotBucketsViewControllerMode = mode
    }
    
    func loadBuckets() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
        
            switch shotBucketsViewControllerMode {
                
            case .AddToBucket:
                firstly {
                    bucketsProvider.provideMyBuckets()
                }.then { buckets in
                    self.buckets = buckets ?? []
                }.then(fulfill).error(reject)
                
            case .RemoveFromBucket:
                firstly {
                    shotsRequester.userBucketsForShot(shot)
                }.then { buckets in
                    self.buckets = buckets ?? []
                }.then(fulfill).error(reject)
            }
        }
    }
    
    func addShotToBucketAtIndex(index: Int) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
        
            firstly {
                bucketsRequester.addShot(shot, toBucket: buckets[index])
            }.then(fulfill).error(reject)
        }
    }
    
    func removeShotFromSelectedBuckets() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            
            var bucketsToRemoveShot = [BucketType]()
            selectedBucketsIndexes.forEach {
                bucketsToRemoveShot.append(buckets[$0])
            }
            
            when(bucketsToRemoveShot.map { bucketsRequester.removeShot(shot, fromBucket: $0) }).then(fulfill).error(reject)
        }
    }
    
    func selectBucketAtIndex(index: Int) -> Bool {
        toggleBucketSelectionAtIndex(index)
        return selectedBucketsIndexes.contains(index)
    }
    
    func bucketShouldBeSelectedAtIndex(index: Int) -> Bool {
        return selectedBucketsIndexes.contains(index)
    }
    
    func showBottomSeparatorForBucketAtIndex(index: Int) -> Bool {
        return index != buckets.count - 1
    }
    
    func isSeparatorCellAtIndex(index: Int) -> Bool {
        switch shotBucketsViewControllerMode {
        case .AddToBucket:
            return false
        case .RemoveFromBucket:
            return index == itemsCount - 2
        }
    }
    
    func isRemoveCellAtIndex(index: Int) -> Bool {
        switch shotBucketsViewControllerMode {
        case .AddToBucket:
            return false
        case .RemoveFromBucket:
            return index == itemsCount - 1
        }
    }
    
    func displayableDataForBucketAtIndex(index: Int) -> (bucketName: String, shotsCountText: String) {
        let bucket = buckets[index]
        return (
            bucketName: bucket.name,
            shotsCountText: bucket.shotsCount == 1 ? "\(bucket.shotsCount) shot" : "\(bucket.shotsCount) shots"
        )
    }
}

private extension ShotBucketsViewModel {
    
    func toggleBucketSelectionAtIndex(index: Int) {
        if let elementIndex = selectedBucketsIndexes.indexOf(index) {
            selectedBucketsIndexes.removeAtIndex(elementIndex)
        } else {
            selectedBucketsIndexes.append(index)
        }
    }
}