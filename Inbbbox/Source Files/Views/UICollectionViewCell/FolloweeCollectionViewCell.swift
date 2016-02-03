//
//  FolloweeCollectionViewCell.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 27.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class FolloweeCollectionViewCell: UICollectionViewCell, Reusable, WidthDependentHeight {
    
    private let shotsView = UIView.newAutoLayoutView()
    private let infoView = UIView.newAutoLayoutView()
    
    private let firstShotImageView = UIImageView.newAutoLayoutView()
    private let secondShotImageView = UIImageView.newAutoLayoutView()
    private let thirdShotImageView = UIImageView.newAutoLayoutView()
    private let fourthShotImageView = UIImageView.newAutoLayoutView()
    
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
    
    private var _shotImagesUrlStrings: [String]? = nil
    var shotImagesUrlStrings: [String]? {
        get {
            return self._shotImagesUrlStrings
        }
        set {
            self._shotImagesUrlStrings = newValue
            showShotImageViews()
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
        shotsView.layer.cornerRadius = 5
        shotsView.clipsToBounds = true
        shotsView.addSubview(firstShotImageView)
        shotsView.addSubview(secondShotImageView)
        shotsView.addSubview(thirdShotImageView)
        shotsView.addSubview(fourthShotImageView)
        
        avatarView = AvatarView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(15, 15)))
        avatarView.imageView.backgroundColor = UIColor.backgroundGrayColor()
        avatarView.configureForAutoLayout()
        infoView.addSubview(avatarView)
        
        infoView.addSubview(infoLabel)
        
        contentView.addSubview(shotsView)
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
            shotsView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            infoView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            infoView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotsView)
            setShotsViewConstraints()
            setInfoViewConstraints()
            didSetConstraints = true
        }
    }
    
    //MARK - Setting constraints
    
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
        infoLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: infoView)
        infoLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
        infoLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoView)
        avatarView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView)
        avatarView.autoSetDimension(.Width, toSize: 15)
        avatarView.autoPinEdge(.Top, toEdge: .Top, ofView: infoLabel)
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "FolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1)
    }
    
    func showShotImageViews() {
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
