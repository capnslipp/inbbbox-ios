//
//  LikeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LikeCollectionViewCell: UICollectionViewCell, Reusable, WidthDependedHeight {
    
    let shotImageView = UIImageView.newAutoLayoutView()
    private var didSetConstraints = false

    // MARK - Life cycle
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.backgroundGrayColor()
        contentView.addSubview(shotImageView)
    }
    
    // MARK - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool{
        return true
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !didSetConstraints {
            shotImageView.autoPinEdgesToSuperviewEdges()
            didSetConstraints = true
        }
    }
    
    // MARK: - Reusable
    static var reuseIdentifier: String {
        return "LikeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependend height
    static var heightToWidthRatio: CGFloat {
        return CGFloat(0.75)
    }
}
