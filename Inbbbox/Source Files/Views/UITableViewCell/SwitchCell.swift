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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor = UIColor.backgroundGrayColor()
        textLabel?.textColor = UIColor.textDarkColor()
        
        switchControl.frame = CGRect(x: 300, y: 5, width: 50, height: 40) // NGRTemp: temp frame
        
        switchControl.tintColor = UIColor.grayColor() //NGRTemp: color will be defined
        switchControl.backgroundColor = switchControl.tintColor
        switchControl.layer.cornerRadius = 18.0;
        switchControl.thumbTintColor = UIColor.whiteColor()
        switchControl.onTintColor = UIColor.pinkColor()
        
        contentView.addSubview(switchControl)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
