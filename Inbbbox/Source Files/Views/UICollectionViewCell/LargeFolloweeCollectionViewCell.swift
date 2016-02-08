//
//  LargeFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 03.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LargeFolloweeCollectionViewCell: BaseFolloweeCollectionViewCell, Reusable, WidthDependentHeight, FolloweeCellConfigurable {
    
    let shotImageView = UIImageView.newAutoLayoutView()
    private var didSetConstraints = false
    
    // MARK: - Lifecycle
    
    override func commonInit() {
        super.commonInit()
        setupShotsView()
    }
    
    // MARK: - UIView
    
    override func updateConstraints() {
        if !didSetConstraints {
            setShotsViewConstraints()
            setInfoViewConstraints()
            didSetConstraints = true
        }
        super.updateConstraints()
    }
    
    // MARK: - Followee Cell Configurable
    
    func setupShotsView() {
        shotImageView.backgroundColor = UIColor.followeeShotGrayColor()
        shotsView.addSubview(shotImageView)
    }
    
    func setShotsViewConstraints() {
        shotImageView.autoPinEdgesToSuperviewEdges()
    }
    
    func setInfoViewConstraints() {
        avatarView.autoSetDimensionsToSize(avatarSize)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView, withOffset: 2)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoView, withOffset: 10)
        
        userNameLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: avatarView)
        userNameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 3)
        userNameLabel.autoPinEdge(.Right, toEdge: .Left, ofView: numberOfShotsLabel)
        
        numberOfShotsLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView, withOffset: -2)
        numberOfShotsLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: userNameLabel)
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "LargeFolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(0.83)
    }
}
