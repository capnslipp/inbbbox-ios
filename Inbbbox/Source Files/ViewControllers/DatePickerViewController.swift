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

    @available(*, unavailable, message="Use init(date:completion:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable, message="Use init(date:completion:) instead")
    override init(nibName: String?, bundle: NSBundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    override func loadView() {
        aView = loadViewWithClass(DatePickerView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("DatePickerViewController.SetReminder",
                comment: "Button title when users accepts selected date for reminder.")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save,
                target: self, action: #selector(didTapSaveButton(_:)))

        aView?.datePicker.date = initialDate
    }

    func didTapSaveButton(sender: UIBarButtonItem) {
        completion(aView!.datePicker.date)
        navigationController?.popViewControllerAnimated(true)
    }
}
