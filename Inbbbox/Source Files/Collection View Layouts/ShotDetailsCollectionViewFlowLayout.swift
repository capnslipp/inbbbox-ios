//
//  ShotDetailsCollectionViewLayout.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 05.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDetailsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        scrollDirection = .Vertical
        minimumLineSpacing = 0
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let superAttributes = super.layoutAttributesForElementsInRect(rect)
        
        guard let bottomInset = collectionView?.contentInset.bottom where bottomInset > 0 else { return superAttributes }
        
        if let collectionView = collectionView {
            
            let footerElements = superAttributes!.filter {
                if let elemedKind = $0.representedElementKind {
                    return elemedKind == UICollectionElementKindSectionFooter
                }
                return false
            }
            
            // only one footer in collectionView
            if let footer = footerElements.first {
                
                let currentBounds = self.collectionView!.bounds;
                footer.zIndex = 1024
                footer.hidden = false
                let yCenterOffset = currentBounds.origin.y + currentBounds.size.height - footer.size.height/2.0 - collectionView.contentInset.bottom
                footer.center = CGPointMake(CGRectGetMidX(currentBounds), yCenterOffset)
            }
        }
        return superAttributes
    }
}
