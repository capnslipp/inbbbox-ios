//
//  SegmentedItem.swift
//  Inbbbox
//
//  Created by Peter Bruz on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SegmentedItem: GroupItem {
    
    private var staticTitle: String
    var currentValue: Int
    var onValueChange: ((selectedSegmentIndex: Int) -> Void)?
    private weak var segmentedControl: UISegmentedControl?
    
    init(title: String, currentValue: Int? = 10) {
        self.staticTitle = title
        self.currentValue = currentValue ?? 10
        super.init(title: title + ": \(self.currentValue)", category: .Segmented)
    }
    
    func bindSegmentedControl(segmentedControl: UISegmentedControl) {
        self.segmentedControl = segmentedControl
        self.segmentedControl?.addTarget(self, action: "didChangeSegment:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindSegmentedControl() {
        segmentedControl?.removeTarget(self, action: "didChangeSegment:forEvents:", forControlEvents: .ValueChanged)
    }
    
    dynamic func didChangeSegment(sender: UISegmentedControl, forEvents events: UIControlEvents) {
        onValueChange?(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
}

extension SegmentedItem: Updatable {
    func update() {
        title = staticTitle + ": \(currentValue)"
    }
}

extension SegmentedItem {
    func increaseValue() {
        currentValue++
    }
    
    func decreaseValue() {
        if currentValue > 0 { currentValue-- }
    }
}
