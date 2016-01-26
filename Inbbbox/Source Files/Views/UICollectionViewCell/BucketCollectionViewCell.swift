//
//  BucketCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BucketCollectionViewCell: UICollectionViewCell, HeightDeclaring, WidthDeclaring, Reusable {
    
    // MARK - Life cycle
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // NGRTemp: temporary implementation
        contentView.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1)
    }
    
    // MARK: - HeightDeclaring
    static var preferredHeight: CGFloat {
        return CGFloat(170)
    }

    // MARK: - WidthDeclaring
    static var preferredWidth: CGFloat {
        return CGFloat(140)
    }
    
    // MARK: - Reusable
    static var reuseIdentifier: String {
        return "BucketCollectionViewCellIdentifier"
    }
}
