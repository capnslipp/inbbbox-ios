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
    private let contentView = UIView()
    private let separatorLine = UIView()
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.backgroundGrayColor()
        
        contentView.backgroundColor = UIColor.whiteColor()
        addSubview(contentView)
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = .Time
        contentView.addSubview(datePicker)
        
        separatorLine.backgroundColor = UIColor.RGBA(224, 224, 224, 1)
        contentView.addSubview(separatorLine)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(_: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints {
            didSetConstraints = true
            
            contentView.autoAlignAxisToSuperviewAxis(.Vertical)
            contentView.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            contentView.autoSetDimension(.Height, toSize: 217)
            contentView.autoPinEdgeToSuperviewEdge(.Top)
            
            datePicker.autoCenterInSuperview()
            datePicker.autoMatchDimension(.Width, toDimension: .Width, ofView: contentView)
            datePicker.autoSetDimension(.Height, toSize: 177)
            
            separatorLine.autoAlignAxisToSuperviewAxis(.Vertical)
            separatorLine.autoMatchDimension(.Width, toDimension: .Width, ofView: contentView)
            separatorLine.autoSetDimension(.Height, toSize: 1)
            separatorLine.autoPinEdgeToSuperviewEdge(.Bottom, withInset: -1)
        }
        
        super.updateConstraints()
    }
}
