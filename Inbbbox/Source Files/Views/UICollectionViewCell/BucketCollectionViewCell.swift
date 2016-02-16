//
//  BucketCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 22.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BucketCollectionViewCell: BaseInfoShotsCollectionViewCell, Reusable, WidthDependentHeight, InfoShotsCellConfigurable {
    
    let firstShotImageView = UIImageView.newAutoLayoutView()
    let secondShotImageView = UIImageView.newAutoLayoutView()
    let thirdShotImageView = UIImageView.newAutoLayoutView()
    let fourthShotImageView = UIImageView.newAutoLayoutView()
    
    override var shotsViewHeightToWidthRatio: CGFloat {
        return 1
    }
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
    
    // MARK: - Info Shots Cell Configurable
    
    func setupShotsView() {
        for view in [firstShotImageView, secondShotImageView, thirdShotImageView, fourthShotImageView] {
            view.backgroundColor = UIColor.followeeShotGrayColor()
            shotsView.addSubview(view)
        }
    }
    
    func setShotsViewConstraints() {
        let spacings = CollectionViewLayoutSpacings()
        let shotImageViewSideLenght = contentView.bounds.width
        let secondaryImageViewWidth = contentView.bounds.width / 3
        let secondaryImageViewHeight = secondaryImageViewWidth * spacings.shotHeightToWidthRatio
        
        
        firstShotImageView.autoSetDimension(.Width, toSize: shotImageViewSideLenght)
        firstShotImageView.autoSetDimension(.Height, toSize: shotImageViewSideLenght * spacings.shotHeightToWidthRatio)
        
        for imageView in [secondShotImageView, thirdShotImageView, fourthShotImageView] {
            imageView.autoSetDimension(.Width, toSize: secondaryImageViewWidth)
            imageView.autoSetDimension(.Height, toSize: secondaryImageViewHeight)
        }
        
        firstShotImageView.autoPinEdge(.Top, toEdge: .Top, ofView: shotsView)
        firstShotImageView.autoPinEdge(.Left, toEdge: .Left, ofView: shotsView)
        firstShotImageView.autoPinEdge(.Right, toEdge: .Right, ofView: shotsView)
        
        secondShotImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: firstShotImageView)
        secondShotImageView.autoPinEdge(.Left, toEdge: .Left, ofView: shotsView)
        secondShotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: shotsView)
        secondShotImageView.autoPinEdge(.Right, toEdge: .Left, ofView: thirdShotImageView)
        
        thirdShotImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: firstShotImageView)
        thirdShotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: shotsView)
        thirdShotImageView.autoPinEdge(.Right, toEdge: .Left, ofView: fourthShotImageView)
        
        fourthShotImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: shotsView)
        fourthShotImageView.autoPinEdge(.Right, toEdge: .Right, ofView: shotsView)
        fourthShotImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: firstShotImageView)
    }
    
    func setInfoViewConstraints() {
        nameLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: numberOfShotsLabel)
        nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: infoView, withOffset: 6.5)
        nameLabel.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        nameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView)
        numberOfShotsLabel.autoPinEdge(.Left, toEdge: .Left, ofView: nameLabel)
    }
    
    func clearImages() {
        for imageView in [firstShotImageView, secondShotImageView, thirdShotImageView, fourthShotImageView] {
            imageView.image = nil
        }
    }
    
    // MARK: - Reusable
    static var reuseIdentifier: String {
        return "BucketCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1.25)
    }
}
