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
    
    let closeButton = UIButton(forAutoLayout: ())
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    
    private var didSetConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addSubview(closeButton)
        
        blurView.configureForAutoLayout()
        addSubview(blurView)
    }

    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            closeButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 44)
            closeButton.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -20.0)
            
            blurView.autoPinEdgesToSuperviewEdges()
            didSetConstraints = true
        }
        super.updateConstraints()
    }
}
