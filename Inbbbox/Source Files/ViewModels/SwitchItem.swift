//
//  SwitchItem.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SwitchItem: GroupItem {

    var isOn = false
    var onValueChanged: ((bool: Bool) -> Void)?
    private weak var switchControl: UISwitch?

    init(title: String, isOn: Bool? = false) {
        self.isOn = isOn ?? false
        super.init(title: title, category: .Boolean)
    }

    func bindSwitchControl(switchControl: UISwitch) {
        self.switchControl = switchControl
        self.switchControl?.addTarget(self, action: #selector(didChangeSwitchState(_: forEvents:)),
        forControlEvents: .ValueChanged)
    }

    func unbindSwitchControl() {
        switchControl?.removeTarget(self, action: #selector(didChangeSwitchState(_: forEvents:)),
        forControlEvents: .ValueChanged)
    }

    dynamic func didChangeSwitchState(sender: UISwitch, forEvents events: UIControlEvents) {
        isOn = sender.on
        onValueChanged?(bool: sender.on)
    }
}
