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
        shotsView.addSubview(shotImageView)
    }
    
    // MARK - Setting constraints
    
    override func setShotsViewConstraints() {
        shotImageView.autoPinEdgesToSuperviewEdges()
    }
    
    override func setInfoViewConstraints() {
        userNameLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        userNameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
        numberOfShotsLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        numberOfShotsLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView)
        avatarView.autoAlignAxisToSuperviewAxis(.Horizontal)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        avatarView.autoSetDimensionsToSize(avatarSize)
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "LargeFolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1)
    }
    
    //MARK: - Data filling
    
    override func showShotImages() {
        if let shotImageUrlString = shotImagesUrlStrings?.first {
            shotImageView.loadImageFromURLString(shotImageUrlString)
        }
    }
}
