//
//  UICollectionViewExtensions.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UICollectionView {

    enum Type {
        case Cell, Header, Footer
    }

    func registerClass<T: UICollectionReusableView where T: Reusable>(aClass: T.Type, type: Type) {

        switch(type) {
        case .Cell:
            registerClass(aClass, forCellWithReuseIdentifier: T.reuseIdentifier)
        case .Header:
            registerClass(aClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
        case .Footer:
            registerClass(aClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableClass<T: UICollectionReusableView where T: Reusable>(aClass: T.Type, forIndexPath indexPath: NSIndexPath, type: Type) -> T {

        switch(type) {
        case .Cell:
            return dequeueReusableCellWithReuseIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
        case .Header:
            return dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, forIndexPath: indexPath) as! T
        case .Footer:
            return dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, forIndexPath: indexPath) as! T
        }
    }
    
    func sizeForAutoSizingCell<T: UICollectionViewCell where T: AutoSizable>(cell: T.Type, textToBound: [NSAttributedString?]?, withInsets additionalInsets: UIEdgeInsets = UIEdgeInsetsZero) -> CGSize {
        
        let insets = cell.contentInsets
        let availableWidth = bounds.size.width - (cell.maximumContentWidth ?? 0) - (insets.left + insets.right + additionalInsets.left + additionalInsets.right)
        var height = CGFloat(0)
        
        if let textToBound = textToBound {
            
            let textToCalculateHeight = textToBound.flatMap { $0 }
            
            if textToCalculateHeight.count > 0 {
                
                textToCalculateHeight.forEach {
                    height += $0.boundingHeightUsingAvailableWidth(availableWidth) + cell.verticalInteritemSpacing
                }
                
                height += insets.top + insets.bottom + additionalInsets.top + additionalInsets.bottom
            }
        }
        
        return CGSize(
            width: bounds.size.width,
            height: max(cell.minimumRequiredHeight, height)
        )
    }
}
