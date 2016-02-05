//
//  SmallFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SmallFolloweeCollectionViewCell: BaseFolloweeCollectionViewCell, Reusable, WidthDependentHeight, FolloweeCellConfigurable {
    
    let firstShotImageView = UIImageView.newAutoLayoutView()
    let secondShotImageView = UIImageView.newAutoLayoutView()
    let thirdShotImageView = UIImageView.newAutoLayoutView()
    let fourthShotImageView = UIImageView.newAutoLayoutView()

    private var didSetConstraints = false
    
    
    // MARK: - Lifecycle
    
    override func commonInit() {
        super.commonInit()
        setupShotsView()
    }
    
    // MARK: - UIView
    
    override func updateConstraints() {
        super.updateConstraints()
        if !didSetConstraints {
            setShotsViewConstraints()
            setInfoViewConstraints()
            didSetConstraints = true
        }
    }
    
    // MARK: - Followee Cell Configurable
    
    func setupShotsView() {
        for view in [firstShotImageView, secondShotImageView, thirdShotImageView, fourthShotImageView] {
            view.backgroundColor = UIColor.followeeShotGrayColor()
            shotsView.addSubview(view)
        }
    }
    
    func setShotsViewConstraints() {
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
    
    func setInfoViewConstraints() {
        avatarView.autoSetDimensionsToSize(avatarSize)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoView, withOffset: 6.5)
        
        userNameLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: numberOfShotsLabel)
        userNameLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: avatarView)
        userNameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 3)
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
}
