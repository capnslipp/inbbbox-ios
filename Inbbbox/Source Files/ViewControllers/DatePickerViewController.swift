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
        
        let contentView = UIView(frame: CGRect(x: CGRectGetMinX(view.frame), y: 64, width: CGRectGetWidth(view.frame), height: 217)) // NGRTemp: temp frame
        contentView.backgroundColor = UIColor.whiteColor()
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = .Time
        datePicker.frame = CGRect(x: 0, y: 20, width: CGRectGetWidth(view.bounds), height: 177) // NGRTemp: temp frame
        
        contentView.addSubview(datePicker)
        
        let separatorLine = UIView(frame: CGRect(x: 0, y: CGRectGetHeight(contentView.frame) - 0.3, width: CGRectGetWidth(contentView.frame), height: 0.3)) // NGRTemp: temp frame
        separatorLine.backgroundColor = UIColor.textLightColor()
        contentView.addSubview(separatorLine)
        
        view.addSubview(contentView)
    }
}
