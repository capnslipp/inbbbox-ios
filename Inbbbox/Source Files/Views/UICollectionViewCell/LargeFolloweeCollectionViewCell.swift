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
    private let infoLabel = UILabel.newAutoLayoutView()
    
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
        
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(15, 15)))
        avatarView.imageView.backgroundColor = UIColor.backgroundGrayColor()
        avatarView.configureForAutoLayout()
        infoView.addSubview(avatarView)
        
        infoView.addSubview(infoLabel)
        
        contentView.addSubview(shotView)
        contentView.addSubview(infoView)
        infoLabel.numberOfLines = 2
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
            setInfoViewConstraints()
            didSetConstraints = true
        }
    }
    
    func setInfoViewConstraints() {
        infoLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: infoView)
        infoLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
        infoLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        avatarView.autoSetDimension(.Width, toSize: 15)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoLabel)
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "LargeFolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1)
    }
    
    func showShotImageView() {
        if let shotImageUrlString = shotImageUrlString {
            shotImageView.loadImageFromURLString(shotImageUrlString)
        }
    }
    
    func showFolloweeInfo() {
        if let avatarString = followee?.avatarString {
            avatarView.imageView.loadImageFromURLString(avatarString)
        }
        configureInfoLabel(followee?.name, numberOfShots: followee?.shotsCount)
    }
    
    func configureInfoLabel(followeeName: String?, numberOfShots: Int?) {
        let name = (followeeName != nil) ? followeeName! : " ";
        let firstLine = NSMutableAttributedString.init(string: name, attributes:[
            // NGRTodo:set proper font and color
            NSForegroundColorAttributeName : UIColor.pinkColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(10)
            ])
        let numberOfShotsText = (numberOfShots != nil) ? "\n\(numberOfShots!) shots" : " "
        let secondLine = NSAttributedString.init(string: numberOfShotsText, attributes:[
            // NGRTodo:set proper font and color
            NSForegroundColorAttributeName : UIColor.textDarkColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(8)
            ])
        firstLine.appendAttributedString(secondLine)
        infoLabel.attributedText = firstLine
    }

}
