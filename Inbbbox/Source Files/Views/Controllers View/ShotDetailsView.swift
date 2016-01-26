//
//  ShotDetailsView.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 21.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class ShotDetailsView: UIView {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        translatesAutoresizingMaskIntoConstraints = false
        
        blurView.configureForAutoLayout()
        tableView.configureForAutoLayout()
        addSubview(blurView)
        addSubview(tableView)
    }

    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            
            self.autoPinEdgesToSuperviewEdges()
            blurView.autoPinEdgesToSuperviewEdges()
            
            tableView.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset:30)
            tableView.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset:0)
            tableView.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset:0)
            tableView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset:0)
            
            didSetConstraints = true
        }
        super.updateConstraints()
    }
}
