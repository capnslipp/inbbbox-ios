//
//  SegmentedItem.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SegmentedItem: GroupItem {
    
    var selectedSegmentIndex = -1
    var onValueChange: ((selectedSegmentIndex: Int) -> Void)?
    private weak var segmentedControl: UISegmentedControl?
    
    init(title: String) {
        super.init(title: title, category: .Segmented)
    }
    
    func bindSegmentedControl(segmentedControl: UISegmentedControl) {
        self.segmentedControl = segmentedControl
        self.segmentedControl?.addTarget(self, action: "didChangeSegment:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindSegmentedControl() {
        segmentedControl?.removeTarget(self, action: "didChangeSegment:forEvents:", forControlEvents: .ValueChanged)
    }
    
    dynamic func didChangeSegment(sender: UISegmentedControl, forEvents events: UIControlEvents) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        onValueChange?(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
}
