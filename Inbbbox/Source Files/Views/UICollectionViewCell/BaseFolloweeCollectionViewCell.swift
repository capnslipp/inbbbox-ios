//
//  BaseFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 04.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BaseFolloweeCollectionViewCell: UICollectionViewCell {
    
    let shotsView = UIImageView.newAutoLayoutView()
    let infoView = UIView.newAutoLayoutView()
    var avatarView: AvatarView!
    let userNameLabel = UILabel.newAutoLayoutView()
    let numberOfShotsLabel = UILabel.newAutoLayoutView()
    let avatarSize = CGSizeMake(15, 15)
    private var didSetConstraints = false
    
    private var _followee: Followee? = nil
    var followee: Followee? {
        get {
            return self._followee
        }
        set {
            self._followee = newValue
            showFolloweeInfo()
        }
    }
    
    private var _shotImagesUrlStrings: [String]? = nil
    var shotImagesUrlStrings: [String]? {
        get {
            return self._shotImagesUrlStrings
        }
        set {
            self._shotImagesUrlStrings = newValue
            showShotImages()
        }
    }
    
    // MARK - Life cycle
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // Mark - Setup UI
    
     func commonInit() {
        setupShotViews()
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: avatarSize), border: false)
        avatarView.imageView.backgroundColor = UIColor.backgroundGrayColor()
        avatarView.configureForAutoLayout()
        infoView.addSubview(avatarView)
        
        userNameLabel.textColor = UIColor.pinkColor()
        userNameLabel.font = UIFont.systemFontOfSize(13, weight:UIFontWeightMedium)
        infoView.addSubview(userNameLabel)
        
        numberOfShotsLabel.textColor = UIColor.followeeTextGrayColor()
        numberOfShotsLabel.font = UIFont.systemFontOfSize(10)
        infoView.addSubview(numberOfShotsLabel)
        
        shotsView.layer.cornerRadius = 5
        shotsView.clipsToBounds = true
        
        contentView.addSubview(shotsView)
        contentView.addSubview(infoView)
    }
    
    func setupShotViews() {
        //Empty implementation - needs to be overrided in subclass
    }
    
    // MARK - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !didSetConstraints {
            let spacings = CollectionViewLayoutSpacings()
            let shotsViewHeight = spacings.shotHeightToWidthRatio * frame.width
            shotsView.autoSetDimension(.Height, toSize: shotsViewHeight)
            shotsView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            infoView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            infoView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotsView)
            setInfoViewConstraints()
            setShotsViewConstraints()
            didSetConstraints = true
        }
    }
    
    func setInfoViewConstraints() {
        //Empty implementation - needs to be overriden in subclass
    }
    
    func setShotsViewConstraints() {
        //Empty implementation - needs to be overriden in subclass
    }
    
    //MARK: - Data filling
    
    func showShotImages() {
        //Empty implementation - needs to be overriden in subclass
    }
    
    func showFolloweeInfo() {
        if let avatarString = followee?.avatarString {
            avatarView.imageView.loadImageFromURLString(avatarString)
        }
        userNameLabel.text = followee?.name
        let numberOfShotsText = (followee?.shotsCount != nil) ? "\(followee!.shotsCount!) shots" : " "
        numberOfShotsLabel.text = numberOfShotsText
    }
}
