//
//  FlashMessageView.swift
//  Inbbbox
//
//  Created by Blazej Wdowikowski on 20/10/2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

extension UIView {
    func roundCorners(corners:UIRectCorner,cornerRadii: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(10, 10))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

class FlashMessageView: UIView {
    let messageLabel:UILabel = {
       let l = UILabel()
        l.numberOfLines = 0
        l.lineBreakMode = .ByWordWrapping
        l.allowsDefaultTighteningForTruncation = true
        l.adjustsFontSizeToFitWidth = true
        l.textColor = UIColor.whiteColor()
        return l
    }()
    
    var message:String? {
        didSet{
            guard
                let message = message else {
                return
            }
            messageLabel.text = message
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Draw
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        roundCorners([.BottomLeft,.BottomRight], cornerRadii: CGSize(width: 10, height: 10))
    }
    
    // MARK: Privates Methods
    
    private func setup() {
        setupMessageLabel()
        setupBackgroud()
    }
    
    private func setupMessageLabel() {
        self.addSubview(messageLabel)
        messageLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(25, 25, 25, 25))
    }
    
    private func setupBackgroud() {
        backgroundColor = UIColor.flashMessageBackgroundColor()
    }
}
