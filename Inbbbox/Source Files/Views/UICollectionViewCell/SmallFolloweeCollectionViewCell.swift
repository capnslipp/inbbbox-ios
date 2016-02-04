//
//  SmallFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SmallFolloweeCollectionViewCell: BaseFolloweeCollectionViewCell, Reusable, WidthDependentHeight {
    
    private let firstShotImageView = UIImageView.newAutoLayoutView()
    private let secondShotImageView = UIImageView.newAutoLayoutView()
    private let thirdShotImageView = UIImageView.newAutoLayoutView()
    private let fourthShotImageView = UIImageView.newAutoLayoutView()
    
    
    // MARK - Setup UI
    
    override func setupShotViews() {
        for view in [firstShotImageView, secondShotImageView, thirdShotImageView, fourthShotImageView] {
            view.backgroundColor = UIColor.followeeShotGrayColor()
            shotsView.addSubview(view)
        }
    }

    // MARK - Setting constraints
    
    override func setShotsViewConstraints() {
        let spacings = CollectionViewLayoutSpacings()
        let shotImageViewWidth = contentView.bounds.width / 2
        let shotImageViewHeight = shotImageViewWidth * spacings.shotHeightToWidthRatio
        
        firstShotImageView.autoSetDimension(.Height, toSize: shotImageViewHeight)
        firstShotImageView.autoSetDimension(.Width, toSize: shotImageViewWidth)
        
        secondShotImageView.autoSetDimension(.Height, toSize: shotImageViewHeight)
        secondShotImageView.autoSetDimension(.Width, toSize: shotImageViewWidth)
        
        thirdShotImageView.autoSetDimension(.Height, toSize: shotImageViewHeight)
        thirdShotImageView.autoSetDimension(.Width, toSize: shotImageViewWidth)
        
        fourthShotImageView.autoSetDimension(.Height, toSize: shotImageViewHeight)
        fourthShotImageView.autoSetDimension(.Width, toSize: shotImageViewWidth)
        
        firstShotImageView.autoPinEdge(.Top, toEdge: .Top, ofView: shotsView)
        firstShotImageView.autoPinEdge(.Left, toEdge: .Left, ofView: shotsView)
        firstShotImageView.autoPinEdge(.Bottom, toEdge: .Top, ofView: thirdShotImageView)
        firstShotImageView.autoPinEdge(.Right, toEdge: .Left, ofView: secondShotImageView)
        
        secondShotImageView.autoPinEdge(.Top, toEdge: .Top, ofView: shotsView)
        secondShotImageView.autoPinEdge(.Right, toEdge: .Right, ofView: shotsView)
        secondShotImageView.autoPinEdge(.Bottom, toEdge: .Top, ofView: fourthShotImageView)
        
        thirdShotImageView.autoPinEdge(.Left, toEdge: .Left, ofView: shotsView)
        thirdShotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: shotsView)
        thirdShotImageView.autoPinEdge(.Right, toEdge: .Left, ofView: fourthShotImageView)
        
        fourthShotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: shotsView)
        fourthShotImageView.autoPinEdge(.Right, toEdge: .Right, ofView: shotsView)
    }
    
    override func setInfoViewConstraints() {
        avatarView.autoSetDimensionsToSize(avatarSize)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoView, withOffset: 5)
        
        userNameLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: numberOfShotsLabel)
        userNameLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: avatarView)
        userNameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
        userNameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView)

        numberOfShotsLabel.autoPinEdge(.Left, toEdge: .Left, ofView: userNameLabel)
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "SmallFolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1)
    }
    
    //MARK: - Data filling
    
    override func showShotImages() {
        guard let shotImagesUrlStrings = shotImagesUrlStrings else {
            return
        }
        switch shotImagesUrlStrings.count {
        case 0:
            return
        case 1:
            firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        case 2:
            firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        case 3:
            firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[2])
            fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
        default:
            firstShotImageView.loadImageFromURLString(shotImagesUrlStrings[0])
            secondShotImageView.loadImageFromURLString(shotImagesUrlStrings[1])
            thirdShotImageView.loadImageFromURLString(shotImagesUrlStrings[2])
            fourthShotImageView.loadImageFromURLString(shotImagesUrlStrings[3])
        }
    }
}
