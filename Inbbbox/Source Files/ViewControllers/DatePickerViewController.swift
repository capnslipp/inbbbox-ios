//
//  DatePickerViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

// NGRTemp: temporary implementation
class DatePickerViewController: UIViewController {
    
    private var datePicker = UIDatePicker()
    
    private let completion: NSDate -> Void
    
    init(date: NSDate, completion: NSDate -> Void) {
        datePicker.date = date
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("inbbbox", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "didTapSaveButton:")
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        completion(datePicker.date)
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: Private

extension DatePickerViewController {
    
    private func commonInit() {
        
        view.backgroundColor = UIColor.backgroundGrayColor()
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = .Time
        datePicker.frame = CGRect(x: 0, y: 64, width: CGRectGetWidth(view.bounds), height: 150) // NGRTemp: temp frame
        view.addSubview(datePicker)
    }
}
