//
//  AutoScrollableShotsView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AutoScrollableShotsView: UIView {
    
    private(set) var colectionViews = [UICollectionView]()
    
    init(numberOfColumns: Int) {
        super.init(frame: CGRectZero)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        while colectionViews.count < numberOfColumns {
            
            let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
//            collectionView.userInteractionEnabled = false
            addSubview(collectionView)
            
            colectionViews.append(collectionView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //NGRTodo: Use autolayout
        let columnWidth = CGRectGetWidth(bounds) / CGFloat(colectionViews.count)
        for (index, collectionView) in colectionViews.enumerate() {
            collectionView.frame = CGRect(
                x: columnWidth * CGFloat(index),
                y: 0,
                width: columnWidth,
                height: CGRectGetHeight(bounds)
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
