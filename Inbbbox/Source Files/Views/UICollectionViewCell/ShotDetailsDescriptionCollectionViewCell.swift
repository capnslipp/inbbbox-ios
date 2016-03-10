//
//  ShotDetailsDescriptionCollectionViewCell.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 19/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
import UIKit

class ShotDetailsDescriptionCollectionViewCell: UICollectionViewCell {
    
    let descriptionLabel = UILabel.newAutoLayoutView()
    var shouldShowSeparatorView = true {
        willSet(newValue) {
            let sepratorVisibilityDependentOffset = self.dynamicType.contentInsets.bottom
            separatorView.hidden = !newValue
            descriptionLabelBottomEdgeConstraint?.constant = newValue ? -(2 * sepratorVisibilityDependentOffset) : -sepratorVisibilityDependentOffset
            separatorViewBottomEdgeConstraint?.constant = newValue ? -sepratorVisibilityDependentOffset : 0
        }
    }
    
    private let separatorView = UIView.newAutoLayoutView()
    private var didUpdateConstraints = false
    private var descriptionLabelBottomEdgeConstraint: NSLayoutConstraint?
    private var separatorViewBottomEdgeConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        separatorView.backgroundColor = UIColor.RGBA(246, 248, 248, 1)
        contentView.addSubview(separatorView)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = self.dynamicType.contentInsets
        descriptionLabel.preferredMaxLayoutWidth = frame.size.width - insets.left - insets.right
    }

    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let insets = self.dynamicType.contentInsets
            descriptionLabel.autoPinEdgesToSuperviewEdgesWithInsets(insets, excludingEdge: .Bottom)
            descriptionLabelBottomEdgeConstraint = descriptionLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: insets.bottom)
            
            separatorView.autoSetDimension(.Height, toSize: 1)
            separatorView.autoPinEdgeToSuperviewEdge(.Left)
            separatorView.autoPinEdgeToSuperviewEdge(.Right)
            separatorViewBottomEdgeConstraint = separatorView.autoPinEdgeToSuperviewEdge(.Bottom)
        }
        
        super.updateConstraints()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        
        descriptionLabel.attributedText = nil
    }
}

extension ShotDetailsDescriptionCollectionViewCell: AutoSizable {
        
    static var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension ShotDetailsDescriptionCollectionViewCell: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsDescriptionCollectionViewCell)
    }
}
