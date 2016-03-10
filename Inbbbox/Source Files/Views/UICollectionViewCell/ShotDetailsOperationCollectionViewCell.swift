//
//  ShotDetailsOperationCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 23/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDetailsOperationCollectionViewCell: UICollectionViewCell {
    
    let operationView = ShotDetailsOperationView.newAutoLayoutView()
    private var didUpdateConstraints = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(operationView)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true

            operationView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
        
        super.updateConstraints()
    }
}

extension ShotDetailsOperationCollectionViewCell: AutoSizable {
    
    static var minimumRequiredHeight: CGFloat {
        return ShotDetailsOperationView.minimumRequiredHeight
    }
}

extension ShotDetailsOperationCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsOperationCollectionViewCell)
    }
}
