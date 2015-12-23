//
//  SegmentedCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SegmentedCell: BaseCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewSegmentedCellReuseIdentifier"
    }
    
    let segmentedControl = UISegmentedControl()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        segmentedControl.frame = CGRect(x: 265, y: 7, width: 94, height: 29) // NGRTemp: temp frame
        
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("-", comment: ""), atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("+", comment: ""), atIndex: 1, animated: false)
        
        segmentedControl.selectedSegmentIndex = -1
        
        segmentedControl.tintColor = UIColor.pinkColor()
        contentView.insertSubview(segmentedControl, aboveSubview: textLabel!)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
