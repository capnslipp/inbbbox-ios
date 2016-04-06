//
//  UICollectionViewExtensions.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
extension UICollectionView {

    /// Defines type used during registering class for reusable view.
    enum Type {
        case Cell, Header, Footer
    }

    /// Registers class for reuse.
    /// Specific registration method is choosed based on view type.
    /// - parameter aClass: Class to register.
    /// - parameter type: Type of reusable view.
    /// - SeeAlso: `Type` enum.
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

    /// Dequeues reusable cell or suplementary view based on type.
    /// - parameter aClass: Class to dequeue.
    /// - parameter forIndexPath: The index path specifying the location of the cell or view.
    /// - parameter type: Type of reusable view.
    /// - SeeAlso: `Type` enum.
    /// - Returns: A valid UICollectionReusableView object.
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
    
    /// Calculates size for auto sizing cell.
    /// - parameter cell: Cell for which calculation happens. Must be of `Type`.
    /// - parameter textToBound: Optional text that will be considered during calculations.
    /// - parameter withInsets: Set insets if needed.
    /// - SeeAlso: `Type` enum.
    /// - Returns: Size of cell.
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
