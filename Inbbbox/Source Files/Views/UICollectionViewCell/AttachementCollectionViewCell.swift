//
//  AttachementCollectionViewCell.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 15.11.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class AttachementCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView.newAutoLayoutView()
    private let attachementIconImageView = UIImageView.newAutoLayoutView()
    
    
    private var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureForAutoLayout()
        
        contentView.configureForAutoLayout()
        contentView.backgroundColor = .clearColor()
        
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        contentView.addSubview(imageView)
        
        attachementIconImageView.image = UIImage(named: "ic_attachement")
        attachementIconImageView.contentMode = .Center
        attachementIconImageView.layer.cornerRadius = 9
        attachementIconImageView.backgroundColor = UIColor.RGBA(175, 175, 175, 0.26)
        contentView.addSubview(attachementIconImageView)
        
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message = "Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            imageView.autoPinEdgesToSuperviewEdges()
            attachementIconImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: 3)
            attachementIconImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 3)
            attachementIconImageView.autoSetDimensionsToSize(CGSizeMake(18, 18))
            
            contentView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }
}

extension AttachementCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(AttachementCollectionViewCell)
    }
}
