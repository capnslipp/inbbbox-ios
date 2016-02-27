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

        if hasBucketsToFetch {
            counter += buckets.count
        }
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
    
    private var selectedBucketsIndexes = [Int]()
    
    private var hasBucketsToFetch: Bool {
        return shot.bucketsCount != 0
    }
    
    let shot: ShotType
    private(set) var buckets = [Bucket]()
    
    let shotBucketsViewControllerMode: ShotBucketsViewControllerMode
    
    init(shot: ShotType, mode: ShotBucketsViewControllerMode) {
        self.shot = shot
        shotBucketsViewControllerMode = mode
    }
    
    // NGRTodo: implement method
    func loadBuckets() -> Promise<Void> {
        switch shotBucketsViewControllerMode {
        case .AddToBucket:
            print(true)
            return Promise()
        case .RemoveFromBucket:
            print(true)
            return Promise()
        }
    }
    
    // NGRTodo: implement method
    func addShotToBucketAtIndex(index: Int) -> Promise<Void> {
        return Promise()
    }
    
    // NGRTodo: implement method
    func removeShotFromSelectedBuckets() -> Promise<Void> {
        return Promise()
    }
    
    func selectBucketAtIndex(index: Int) -> Bool {
        toggleBucketSelectionAtIndex(index)
        return selectedBucketsIndexes.contains(index)
    }
    
    func bucketShouldBeSelectedAtIndex(index: Int) -> Bool {
        return selectedBucketsIndexes.contains(index)
    }
    
    func showBottomSeparatorForBucketAtIndex(index: Int) -> Bool {
        return index != 2 // NGRTemp:
    }
    
    func isSeparatorCellAtIndex(index: Int) -> Bool {
        return index == 3 // NGRTemp:
    }
    
    func isRemoveCellAtIndex(index: Int) -> Bool {
        return index == 4 // NGRTemp:
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
