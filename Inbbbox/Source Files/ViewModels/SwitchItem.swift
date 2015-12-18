//
//  SwitchItem.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SwitchItem: GroupItem {
    
    var on = false
    var onValueChanged: ((bool: Bool) -> Void)?
    private weak var switchControl: UISwitch?
    
    init(title: String) {
        super.init(title: title, category: .Boolean)
    }
    
    func bindSwitchControl(switchControl: UISwitch) {
        self.switchControl = switchControl
        self.switchControl?.addTarget(self, action: "didChangeSwitchState:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindSwitchControl() {
        self.switchControl?.removeTarget(self, action: "didChangeSwitchState:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func didChangeSwitchState(sender: UISwitch, forEvents events: UIControlEvents) {
        on = sender.on
        onValueChanged?(bool: sender.on)
    }
}
