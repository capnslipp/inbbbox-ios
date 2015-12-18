//
//  GroupedBaseTableView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class GroupedBaseTableView: UIBaseTableView {
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Grouped)
    }
}
