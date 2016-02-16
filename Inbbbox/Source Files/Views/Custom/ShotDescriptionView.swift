//
//  ShotDescriptionView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDescriptionView: UIView{
    
    // Public
    var descriptionText: NSMutableAttributedString? {
        didSet {
            descriptionLabel.text = descriptionText?.string
            setNeedsLayout()
            setNeedsUpdateConstraints()
        }
    }
    
    // Private Properties
    private var didUpdateConstraints = false
    private let topInset = CGFloat(10)
    private let bottomInset = CGFloat(10)
    
    // Colors
    private let viewBackgroundColor = UIColor(red: 0.9999, green: 1.0, blue: 0.9998, alpha: 1.0)
    
    // Private UI Components
    private let topSeparatorLine = UIView.newAutoLayoutView()
    private let descriptionLabel = UILabel()
    private let bottomSeparatorLine = UIView.newAutoLayoutView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = viewBackgroundColor
        setupSubviews()
    }
    
    @available(*, unavailable, message="Use init(frame: CGRect) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        let leftAndRightInset = CGFloat(20)
        let separatorLinesHeight = CGFloat(1)
        
        if !didUpdateConstraints {
            
            topSeparatorLine.autoPinEdgeToSuperviewEdge(.Top)
            topSeparatorLine.autoSetDimension(.Height, toSize: separatorLinesHeight)
            topSeparatorLine.autoPinEdgeToSuperviewEdge(.Left)
            topSeparatorLine.autoPinEdgeToSuperviewEdge(.Right)
            
            descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: topSeparatorLine, withOffset: topInset)
            descriptionLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: leftAndRightInset)
            descriptionLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: leftAndRightInset)
            
            bottomSeparatorLine.autoPinEdge(.Top, toEdge: .Bottom, ofView: descriptionLabel, withOffset: bottomInset)
            bottomSeparatorLine.autoSetDimension(.Height, toSize: separatorLinesHeight)
            bottomSeparatorLine.autoPinEdgeToSuperviewEdge(.Left)
            bottomSeparatorLine.autoPinEdgeToSuperviewEdge(.Right)
            bottomSeparatorLine.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
 
    private func setupSubviews() {
        setupDescriptionLabel()
        setupSeparatorLines()
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = descriptionText?.string
        descriptionLabel.font = UIFont.helveticaFont(.Neue, size: 15)
        descriptionLabel.textColor = UIColor.textLightColor()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.backgroundColor = UIColor(red: 0.9999, green: 1.0, blue: 0.9998, alpha: 1.0 )
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.tintColor = UIColor.textLightColor()
        addSubview(descriptionLabel)
    }
    
    private func setupSeparatorLines() {
        topSeparatorLine.backgroundColor = UIColor.RGBA(223, 224, 226, 1)
        bottomSeparatorLine.backgroundColor = UIColor.RGBA(223, 224, 226, 1)
        addSubview(topSeparatorLine)
        addSubview(bottomSeparatorLine)
    }
}
