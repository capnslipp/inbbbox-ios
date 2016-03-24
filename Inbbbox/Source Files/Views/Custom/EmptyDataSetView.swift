//
//  EmptyDataSetView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EmptyDataSetView: UIView {
    
    private let descriptionLabel = UILabel.newAutoLayoutView()
    private let imageView = UIImageView.newAutoLayoutView()
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "logo-empty")
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
        
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            imageView.autoAlignAxisToSuperviewAxis(.Vertical)
            imageView.autoAlignAxis(.Horizontal, toSameAxisOfView: imageView.superview!, withOffset: -90)
            imageView.autoSetDimensionsToSize(CGSize(width: 140, height: 140))
            
            descriptionLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView, withOffset: 40)
        }
        super.updateConstraints()
    }
    
    func setDescriptionText(firstLocalizedString firstLocalizedString: String, attachmentImage: UIImage?, imageOffset: CGPoint, lastLocalizedString: String) {
        
        descriptionLabel.attributedText = {
            let compoundAttributedString = NSMutableAttributedString.emptyDataSetStyledString(firstLocalizedString)
            let textAttachment: NSTextAttachment = NSTextAttachment()
            textAttachment.image = attachmentImage
            if let image = textAttachment.image {
                textAttachment.bounds = CGRect(origin: imageOffset, size: image.size)
            }
            let attributedStringWithImage: NSAttributedString = NSAttributedString(attachment: textAttachment)
            compoundAttributedString.appendAttributedString(attributedStringWithImage)
            let lastAttributedString = NSMutableAttributedString.emptyDataSetStyledString(lastLocalizedString)
            compoundAttributedString.appendAttributedString(lastAttributedString)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            compoundAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, compoundAttributedString.length))
            
            return compoundAttributedString
        }()
    }
}
