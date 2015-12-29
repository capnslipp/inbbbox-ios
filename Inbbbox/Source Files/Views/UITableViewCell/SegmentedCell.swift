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
    
    private var didSetConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            segmentedControl.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: contentView, withOffset: -16)
            segmentedControl.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 7)
            segmentedControl.autoSetDimension(.Height, toSize: 29)
            segmentedControl.autoSetDimension(.Width, toSize: 94)
        }
        
        super.updateConstraints()
    }
    
    func commonInit() {
        
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("-", comment: ""), atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle(NSLocalizedString("+", comment: ""), atIndex: 1, animated: false)
        
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        segmentedControl.tintColor = UIColor.pinkColor()
        contentView.insertSubview(segmentedControl, aboveSubview: textLabel!)
        
        setNeedsUpdateConstraints()
    }
}

extension SegmentedCell {
    func clearSelection() {
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
}
