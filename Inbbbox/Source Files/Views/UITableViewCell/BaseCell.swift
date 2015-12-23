//
//  BaseCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customLayout()
    }
    
    private final func customLayout() {
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.textDarkColor()
        
        let separatorLine = UIView(frame: CGRect(x: 15, y: CGRectGetMaxY(frame)-0.3, width: CGRectGetWidth(frame)+50, height: 0.3)) // NGRTemp: temp frame
        separatorLine.backgroundColor = UIColor.textLightColor()
        
        contentView.addSubview(separatorLine)
    }
}
