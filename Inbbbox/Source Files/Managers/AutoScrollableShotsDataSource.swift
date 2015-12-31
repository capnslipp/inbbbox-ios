//
//  AutoScrollableShotsDataSource.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AutoScrollableShotsDataSource: NSObject {

    private typealias AutoScrollableImageContent = (image: UIImage, isDuplicateForExtendedContent: Bool)
    private var content: [AutoScrollableImageContent]!
    
    private(set) var extendedScrollableItemsCount = 0
    var itemSize: CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetWidth(collectionView.bounds))
    }
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, content: [UIImage]) {
        self.collectionView = collectionView
        self.content = content.map { ($0, false) }
        
        super.init()
        
        //NGRTemp: temporary use suhc upproach (till merge proper branch)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(AutoScrollableCollectionViewCell.self, forCellWithReuseIdentifier: AutoScrollableShotsDataSource.reuseIdentifier)
        prepareExtendedContentToDisplayWithOffset(0)
    }
    
    @available(*, unavailable, message="Use init(collectionView:content:) instead")
    override init() {
        fatalError("init() has not been implemented")
    }
    
    func prepareForAnimation() {
        extendedScrollableItemsCount = Int(ceil(CGRectGetHeight(collectionView.bounds) / itemSize.height))
        prepareExtendedContentToDisplayWithOffset(extendedScrollableItemsCount)
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension AutoScrollableShotsDataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AutoScrollableShotsDataSource.reuseIdentifier, forIndexPath: indexPath) as! AutoScrollableCollectionViewCell
        
        cell.imageView.image = content[indexPath.row].image
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension AutoScrollableShotsDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize
    }
}


//NGRTemp: temporary here.
extension AutoScrollableShotsDataSource: Reusable {
    
    class var reuseIdentifier: String {
        return "AutoScrollableCollectionViewCellReuseIdentifier"
    }
}

// MARK: Private

private extension AutoScrollableShotsDataSource {
    
    func prepareExtendedContentToDisplayWithOffset(offset: Int) {
        
        let images = content.filter { !$0.isDuplicateForExtendedContent }
        
        var extendedContent = [AutoScrollableImageContent]()
        
        for index in 0..<(images.count + 2 * offset) {
            
            let indexSubscript: Int
            var isDuplicateForExtendedContent = true
            
            if index < offset {
                indexSubscript = images.count - offset + index
                
            } else if index > images.count + offset - 1 {
                indexSubscript = index - images.count - offset
                
            } else {
                isDuplicateForExtendedContent = false
                indexSubscript = index - offset
            }
            
            extendedContent.append((images[indexSubscript].image, isDuplicateForExtendedContent))
        }
        
        content = extendedContent
    }
}
