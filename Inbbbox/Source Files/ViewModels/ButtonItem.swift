//
//  ButtonItem.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import UIKit

class ButtonItem: GroupItem {
    
    var onButtonTapped: (Void -> Void)?
    private weak var button: UIButton?
    
    init(title: String) {
        super.init(title: title, category: .Action)
    }
    
    func bindButtonControl(buttonControl: UIButton) {
        button = buttonControl
        button?.addTarget(self, action: "didTapButton:forEvents:", forControlEvents: .TouchUpInside)
    }
    
    func unbindButtonControl() {
        button?.removeTarget(self, action: "didTapButton:forEvents:", forControlEvents: .TouchUpInside)
    }
    
    func didTapButton(sender: UIButton, forEvents events: UIControlEvents) {
        onButtonTapped?()
    }
}
