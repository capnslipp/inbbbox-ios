//
//  DateCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewDateCellReuseIdentifier"
    }
    
    let dateLabel = UILabel()
    var shouldBeGreyedOut = false {
        didSet {
            let color: UIColor = shouldBeGreyedOut ? .lightGrayColor() : .blackColor()
            dateLabel.textColor = color
        }
    }
    
    private var textAttributes = [NSObject: AnyObject]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setDateText(text: String) {
        dateLabel.text = text
    }
    
    func commonInit() {
        
        dateLabel.frame = CGRect(x: 270, y: 12, width: 75, height: 21) // NGRTemp: temp frame
        dateLabel.text = ""
        dateLabel.textAlignment = .Right
        contentView.addSubview(dateLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
