//
//  AutoScrollableShotsDataSource.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AutoScrollableShotsDataSource: NSObject {

    /// Count of items extended to simulate infinity scrolling for both, top and bottom respectively
    private(set) var extendedScrollableContentCount = 4
    private var content: [UIImage]!
    
    override init() {
        super.init()
        prepareContentToDisplay()
    }
    
    func registerClassForCollectionView(collectionView: UICollectionView) {
        //NGRTemp: temporary use suhc upproach (till merge proper branch)
        collectionView.registerClass(AutoScrollableCollectionViewCell.self, forCellWithReuseIdentifier: AutoScrollableShotsDataSource.reuseIdentifier)
    }
    
    func sizeForItemInCollectionView(collectionView: UICollectionView) -> CGSize {
        return CGSize(
            width: CGRectGetWidth(collectionView.bounds),
            height: CGRectGetWidth(collectionView.bounds)
        )
    }
    
    func fitExtendedScrollableContentCountForCollectionViews(collectionViews: [UICollectionView]) {
        
        var didPrepareContent = false
        
        for collectionView in collectionViews {
            extendedScrollableContentCount = Int(ceil(CGRectGetHeight(collectionView.bounds) / sizeForItemInCollectionView(collectionView).height))
            
            if !didPrepareContent {
                prepareContentToDisplay()
                didPrepareContent = true
            }
            
            collectionView.reloadData()
        }
    }
}

extension AutoScrollableShotsDataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AutoScrollableShotsDataSource.reuseIdentifier, forIndexPath: indexPath) as! AutoScrollableCollectionViewCell
        
        cell.imageView.image = content[indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
}

extension AutoScrollableShotsDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return sizeForItemInCollectionView(collectionView)
    }
    
}


//NGRTemp: temporary here.
extension AutoScrollableShotsDataSource: Reusable {
    
    class var reuseIdentifier: String {
        return "AutoScrollableCollectionViewCellReuseIdentifier"
    }
}

private extension AutoScrollableShotsDataSource {
    
    func prepareContentToDisplay() {
        
        let images = ShotsStorage().shotsFromAssetCatalog
        var content = [UIImage]()
        
        for index in 0..<(images.count + 2 * extendedScrollableContentCount) {
            
            let indexSubscript: Int
            
            if index < extendedScrollableContentCount {
                indexSubscript = images.count - extendedScrollableContentCount + index
                
            } else if index > images.count + extendedScrollableContentCount - 1 {
                indexSubscript = index - images.count - extendedScrollableContentCount
                
            } else {
                indexSubscript = index - extendedScrollableContentCount
            }
            
            content.append(images[indexSubscript])
        }
        
        self.content = content
    }
}
