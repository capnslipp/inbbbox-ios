//
//  UIBaseTableView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class UIBaseTableView: UIView {
    
    private(set) var tableView = UITableView()
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Plain)
    }
    
    init(frame: CGRect = CGRectZero, tableViewStyle: UITableViewStyle) {
        tableView = UITableView(frame: frame, style: tableViewStyle)
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
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}

