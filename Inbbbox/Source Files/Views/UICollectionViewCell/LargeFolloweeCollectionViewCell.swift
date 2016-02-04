//
//  LargeFolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 03.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LargeFolloweeCollectionViewCell: UICollectionViewCell, Reusable, WidthDependentHeight {
    
    private let shotView = UIImageView.newAutoLayoutView()
    private let shotImageView = UIImageView.newAutoLayoutView()
    private let infoView = UIView.newAutoLayoutView()
    private var avatarView: AvatarView!
    private let userNameLabel = UILabel.newAutoLayoutView()
    private let numberOfShotsLabel = UILabel.newAutoLayoutView()
    private let avatarSize = CGSizeMake(15, 15)
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
    
    private var _shotImageUrlString: String? = nil
    var shotImageUrlString: String? {
        get {
            return self._shotImageUrlString
        }
        set {
            self._shotImageUrlString = newValue
            showShotImageView()
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
    
    func commonInit() {
        shotView.layer.cornerRadius = 5
        shotView.clipsToBounds = true
        shotView.addSubview(shotImageView)
        
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: avatarSize), border: false)
        avatarView.imageView.backgroundColor = UIColor.backgroundGrayColor()
        avatarView.configureForAutoLayout()
        infoView.addSubview(avatarView)
        
        // NGRTodo:set proper font and color
        userNameLabel.textColor = UIColor.pinkColor()
        userNameLabel.font = UIFont.systemFontOfSize(10)
        infoView.addSubview(userNameLabel)
        
        numberOfShotsLabel.textColor = UIColor.darkTextColor()
        numberOfShotsLabel.font = UIFont.systemFontOfSize(8)
        infoView.addSubview(numberOfShotsLabel)
        
        contentView.addSubview(shotView)
        contentView.addSubview(infoView)
    }
    
    // MARK - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !didSetConstraints {
            shotView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            shotImageView.autoPinEdgesToSuperviewEdges()
            infoView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            infoView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotView)
            infoView.autoSetDimension(.Height, toSize: 40)
            setInfoViewConstraints()
            didSetConstraints = true
        }
    }
    
    func setInfoViewConstraints() {
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
    
    func showShotImageView() {
        if let shotImageUrlString = shotImageUrlString {
            shotImageView.loadImageFromURLString(shotImageUrlString)
        }
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
