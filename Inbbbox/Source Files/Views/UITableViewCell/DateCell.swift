//
//  DateCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

class DateCell: UITableViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewDateCellReuseIdentifier"
    }
    
    let dateLabel = UILabel()
    
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
            
            dateLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: contentView, withOffset: 0)
            dateLabel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 12)
            dateLabel.autoSetDimension(.Height, toSize: 21)
            dateLabel.autoSetDimension(.Width, toSize: 80)
        }
        
        super.updateConstraints()
    }
    
    func setDateText(text: String) {
        dateLabel.text = text
    }
    
    func commonInit() {
        
        accessoryType = .DisclosureIndicator
        
        dateLabel.textColor = UIColor.RGBA(164, 180, 188, 1)
        dateLabel.text = ""
        dateLabel.textAlignment = .Right
        contentView.addSubview(dateLabel)
        
        setNeedsUpdateConstraints()
    }
}
