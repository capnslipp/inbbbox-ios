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
    
    var validation: ((date: NSDate) -> NSError?)?
    var onValueChanged: ((date: NSDate) -> Void)?
    
    var highlighted = false
    
    init(title: String, date: NSDate = NSDate()) {
        self.date = date
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
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

// MARK: Testable

extension DateItem: Validatable {
    
    var valueToValidate: AnyObject { return date }
    
    var validationError: NSError? {
        return validate(valueToValidate)
    }
    
    func validate(object: AnyObject) -> NSError? {
        if let date = object as? NSDate {
            return validation?(date: date)
        }
        return nil
    }
}
