//
//  DatePickerViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    private weak var aView: DatePickerView?
    private var initialDate: NSDate!
    
    private var completion: NSDate -> Void
    
    init(date: NSDate, completion: NSDate -> Void) {
        initialDate = date
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        navigationController?.navigationBar.translucent = false
        
        aView = loadViewWithClass(DatePickerView.self)
        aView?.datePicker.date = initialDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("inbbbox", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "didTapSaveButton:")
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        completion(aView!.datePicker.date)
        navigationController?.popViewControllerAnimated(true)
    }
}
