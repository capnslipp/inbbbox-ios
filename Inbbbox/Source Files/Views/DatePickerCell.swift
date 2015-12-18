//
//  DatePickerCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell, Reusable {
    
    var date = NSDate()
    
    class var reuseIdentifier: String {
        return "TableViewDatePickerCellReuseIdentifier"
    }
    
    let datePicker = UIDatePicker()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        datePicker.setDate(date, animated: false)
        datePicker.datePickerMode = .Time
        contentView.addSubview(datePicker)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
