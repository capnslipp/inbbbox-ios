//
//  LargeFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 03.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LargeFolloweeCollectionViewCell: BaseFolloweeCollectionViewCell, Reusable, WidthDependentHeight {
    
    private let shotImageView = UIImageView.newAutoLayoutView()
    
    // MARK - Setup UI
    
    override func setupShotViews() {
        shotImageView.backgroundColor = UIColor.followeeShotGrayColor()
        shotsView.addSubview(shotImageView)
    }
    
    // MARK - Setting constraints
    
    override func setShotsViewConstraints() {
        shotImageView.autoPinEdgesToSuperviewEdges()
    }
    
    override func setInfoViewConstraints() {        
        avatarView.autoSetDimensionsToSize(avatarSize)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView, withOffset: 2)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoView, withOffset: 10)
        
        userNameLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: avatarView)
        userNameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 3)
        userNameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: userNameLabel)
        
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
    
    //MARK: - Data filling
    
    override func showShotImages() {
        if let shotImageUrlString = shotImagesUrlStrings?.first {
            shotImageView.loadImageFromURLString(shotImageUrlString)
        }
    }
}
