//
//  DatePickerItem.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import UIKit
import Async

class DatePickerItem: GroupItem {
    
    var date: NSDate
    var onValueChanged: (date: NSDate) -> Void
    private weak var datePicker: UIDatePicker?
    
    init(date: NSDate, onValueChanged: (date: NSDate) -> Void) {
        self.date = date
        self.onValueChanged = onValueChanged
        super.init(title: "", category: .Picker)
    }
    
    func bindDatePicker(datePicker: UIDatePicker) {
        self.datePicker = datePicker
        Async.main { datePicker.setDate(self.date, animated: false) }
        datePicker.addTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindDatePicker() {
        datePicker?.removeTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func didChangeDate(sender: UIDatePicker, forEvents events: UIControlEvents) {
        date = sender.date
        onValueChanged(date: date)
    }
}
