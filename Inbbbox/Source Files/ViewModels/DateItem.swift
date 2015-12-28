//
//  DateItem.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DateItem: GroupItem {
    
    var date: NSDate
    var dateString: String { return dateFormatter.stringFromDate(date) }
    
    var onValueChanged: ((date: NSDate) -> Void)?
    
    var highlighted = false
    
    init(title: String, date: NSDate? = NSDate()) {
        self.date = date ?? NSDate()
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .NoStyle
        
        super.init(title: title, category: .Date)
    }
    
    private let dateFormatter = NSDateFormatter()
}

// MARK: Updatable

extension DateItem: Updatable {
    
    func update() {
        onValueChanged?(date: date)
    }
}
