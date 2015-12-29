//
//  DatePickerView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    let datePicker = UIDatePicker()
    let contentView = UIView()
    let separatorLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.backgroundGrayColor()
        
        let contentView = UIView(frame: CGRect(x: CGRectGetMinX(frame), y: 0, width: CGRectGetWidth(frame), height: 217)) // NGRTemp: temp frame
        contentView.backgroundColor = UIColor.whiteColor()
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = .Time
        datePicker.frame = CGRect(x: 0, y: 20, width: CGRectGetWidth(bounds), height: 177) // NGRTemp: temp frame
        
        let separatorLine = UIView(frame: CGRect(x: 0, y: CGRectGetHeight(contentView.frame) - 1, width: CGRectGetWidth(contentView.frame), height: 1)) // NGRTemp: temp frame
        separatorLine.backgroundColor = UIColor.RGBA(224, 224, 224, 1)
        
        contentView.addSubview(datePicker)
        contentView.addSubview(separatorLine)
        addSubview(contentView)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
    
    }
}
