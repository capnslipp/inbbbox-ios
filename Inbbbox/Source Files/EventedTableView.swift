//
//  EventedTableView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventedTableView : UITableView {
    
    var didReloadWithData: (Void -> Void)?
    var didReloadWithoutData: (Void -> Void)?
    
    override func reloadData() {
        super.reloadData()
        
        if let datasource = dataSource {
            let numberOfRows = datasource.tableView(self, numberOfRowsInSection: 0)
            numberOfRows > 0 ? didReloadWithData?() : didReloadWithoutData?()
        } else {
            didReloadWithoutData?()
        }
    }
}
