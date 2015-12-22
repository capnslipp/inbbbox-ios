//
//  SegmentedCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SegmentedCell: UITableViewCell, Reusable {
    
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
        
        backgroundColor = UIColor.clearColor()
        
        segmentedControl.frame = CGRect(x: 10, y: 5, width: 300, height: 30) // NGRTemp: temp frame
        
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("Followed", comment: ""), atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("Popular", comment: ""), atIndex: 1, animated: false)
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("Popular +50💗", comment: ""), atIndex: 2, animated: false)
        
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.tintColor = UIColor.redColor() //NGRTemp: color will be defined
        contentView.addSubview(segmentedControl)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        // NGRTodo: implement me!
    }
}
