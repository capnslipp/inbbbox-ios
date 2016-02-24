//
//  GifIndicatorView.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 23.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class GifIndicatorView:UIView {
    
    let gifLabel = UILabel()
    let vibrancyGifLabel = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    
    private var didSetConstraints = false
 
    // MARK: - Life cycle
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gifLabel.configureForAutoLayout()
        gifLabel.text = NSLocalizedString("GIF", comment: "")
        gifLabel.font = UIFont.helveticaFont(.NeueMedium, size: 11)
        gifLabel.textColor = UIColor.textDarkColor()
        gifLabel.textAlignment = .Center
        
        vibrancyGifLabel.contentView.addSubview(gifLabel)
        vibrancyGifLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        vibrancyGifLabel.layer.cornerRadius = 4
        vibrancyGifLabel.clipsToBounds = true
        self.addSubview(vibrancyGifLabel)
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            gifLabel.autoPinEdgesToSuperviewEdges()
            vibrancyGifLabel.autoPinEdgesToSuperviewEdges()
            autoSetDimension(.Width, toSize: 30)
            autoSetDimension(.Height, toSize: 20)
        }
        super.updateConstraints()
    }

}