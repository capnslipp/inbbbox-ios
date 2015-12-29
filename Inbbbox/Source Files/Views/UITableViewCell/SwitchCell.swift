//
//  SwitchCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewSwitchCellReuseIdentifier"
    }
    
    let switchControl = UISwitch()
    
    private var didSetConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            switchControl.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 16)
            switchControl.autoPinEdgeToSuperviewEdge(.Top, withInset: 7)
        }
        
        super.updateConstraints()
    }
    
    func commonInit() {

        switchControl.tintColor = UIColor.RGBA(143, 142, 148, 1)
        switchControl.backgroundColor = switchControl.tintColor
        switchControl.layer.cornerRadius = 18.0;
        switchControl.thumbTintColor = UIColor.whiteColor()
        switchControl.onTintColor = UIColor.pinkColor()
        
        contentView.addSubview(switchControl)
        
        setNeedsUpdateConstraints()
    }
}
