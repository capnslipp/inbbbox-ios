//
//  UserDetailsView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class UserDetailsView: UIView {
    
    let collectionView: UICollectionView
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = 0.75
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.configureForAutoLayout()
        collectionView.backgroundColor = .clearColor()
        
        super.init(frame: frame)
        
        backgroundColor = .backgroundGrayColor()
        addSubview(collectionView)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            collectionView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }
}
