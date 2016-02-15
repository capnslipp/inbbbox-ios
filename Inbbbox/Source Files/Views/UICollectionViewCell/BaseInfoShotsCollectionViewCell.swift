//
//  BaseInfoShotsCollectionViewCell
//  Inbbbox
//
//  Created by Aleksander Popko on 04.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BaseInfoShotsCollectionViewCell: UICollectionViewCell {
    
    let shotsView = UIImageView.newAutoLayoutView()
    let infoView = UIView.newAutoLayoutView()
    let userNameLabel = UILabel.newAutoLayoutView()
    let numberOfShotsLabel = UILabel.newAutoLayoutView()
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
    
    // Mark - Setup UI
    
     func commonInit() {
        
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
    
    // MARK - UIView
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            let spacings = CollectionViewLayoutSpacings()
            let shotsViewHeight = spacings.shotHeightToWidthRatio * frame.width
            shotsView.autoSetDimension(.Height, toSize: shotsViewHeight)
            shotsView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            infoView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            infoView.autoPinEdge(.Top, toEdge: .Bottom, ofView: shotsView)
            didSetConstraints = true
        }
        super.updateConstraints()
    }
}
