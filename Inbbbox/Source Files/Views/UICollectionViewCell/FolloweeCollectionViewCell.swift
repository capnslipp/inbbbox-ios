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
    
    private let avatarImageView = UIImageView.newAutoLayoutView()
    private let infoLabel = UILabel.newAutoLayoutView()
    
    private var didSetConstraints = false
    
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
        shotsView.addSubview(firstShotImageView)
        shotsView.addSubview(secondShotImageView)
        shotsView.addSubview(thirdShotImageView)
        shotsView.addSubview(fourthShotImageView)
        
        infoView.addSubview(avatarImageView)
        infoView.addSubview(infoLabel)
        
        contentView.addSubview(shotsView)
        contentView.addSubview(infoView)
        contentView.backgroundColor = UIColor.cellGrayColor()
        
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
        infoLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarImageView, withOffset: 5)
        avatarImageView.autoPinEdge(.Left, toEdge: .Left, ofView: infoView, withOffset: 5)
        avatarImageView.autoSetDimension(.Width, toSize: 20)
        avatarImageView.autoSetDimension(.Height, toSize: 20)
        avatarImageView.autoPinEdge(.Top, toEdge: .Top, ofView: infoLabel)
     
    }
    
    // MARK: - Reusable
    
    static var reuseIdentifier: String {
        return "FolloweeCollectionViewCellIdentifier"
    }
    
    //MARK: - Width dependent height
    
    static var heightToWidthRatio: CGFloat {
        return CGFloat(1)
    }
    
    func setName(name: String, numberOfShots: Int) {
        let firstLine = NSMutableAttributedString.init(string: name, attributes:[
            // NGRTodo:set proper font and color
            NSForegroundColorAttributeName : UIColor.pinkColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(14)
            ]
        )
        let secondLine = NSAttributedString.init(string: "\n\(numberOfShots) shots", attributes:[
            // NGRTodo:set proper font and color
            NSForegroundColorAttributeName : UIColor.textDarkColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(10)
            ]
        )
        firstLine.appendAttributedString(secondLine)
        infoLabel.attributedText = firstLine
    }
    
    func setAvatar(avatar: UIImage?) {
        avatarImageView.image = avatar
    }
    
    func setShotImages(shotImages: [UIImage]){
        switch shotImages.count {
        case 0:
            return
        case 1:
            firstShotImageView.image = shotImages[0]
            secondShotImageView.image = shotImages[0]
            thirdShotImageView.image = shotImages[0]
            fourthShotImageView.image = shotImages[0]
        case 2:
            firstShotImageView.image = shotImages[0]
            secondShotImageView.image = shotImages[1]
            thirdShotImageView.image = shotImages[1]
            fourthShotImageView.image = shotImages[0]
        case 3:
            firstShotImageView.image = shotImages[0]
            secondShotImageView.image = shotImages[1]
            thirdShotImageView.image = shotImages[2]
            fourthShotImageView.image = shotImages[0]
        default:
            firstShotImageView.image = shotImages[0]
            secondShotImageView.image = shotImages[1]
            thirdShotImageView.image = shotImages[2]
            fourthShotImageView.image = shotImages[3]
        }
    }
}
