//
//  UIBaseTableView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class UIBaseTableView: UIView {
    
    private(set) var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private(set) var tableView = EventedTableView()
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Plain)
    }
    
    init(frame: CGRect = CGRectZero, tableViewStyle: UITableViewStyle) {
        tableView = EventedTableView(frame: frame, style: tableViewStyle)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        tableView.hideSeparatorForEmptyCells()
        addSubview(tableView)
        addSubview(loadingSpinner)
        defineConstraints()
        
        tableView.didReloadWithData = hideLoadingSpinner
        tableView.didReloadWithoutData = {
            if !self.loadingSpinner.isAnimating() {
                self.loadingSpinner.startAnimating()
            }
        }
    }
    
    func hideLoadingSpinner() {
        self.loadingSpinner.stopAnimating()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}

