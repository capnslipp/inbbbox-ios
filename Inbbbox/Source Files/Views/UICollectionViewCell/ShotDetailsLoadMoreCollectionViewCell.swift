//
//  ShotDetailsLoadMoreCollectionViewCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

@objc protocol ShotDetailsLoadMoreCollectionViewCellDelegate: class {
    func shotDetailsLoadMoreCollectionViewCell(view: ShotDetailsLoadMoreCollectionViewCell, didTapLoadMoreButton: UIButton)
}

class ShotDetailsLoadMoreCollectionViewCell: UICollectionViewCell {
    
    // Public
    
    weak var delegate: ShotDetailsLoadMoreCollectionViewCellDelegate?
    
    struct ViewData {
        let commentsCount: String
    }
    
    var viewData: ViewData? {
        didSet {
            loadMoreButton.setTitle("Load more comments (\(viewData!.commentsCount))", forState: .Normal)
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    // Private Properties
    private var didUpdateConstraints = false
    
    // Private UI Components
    private let loadMoreButton = UIButton.newAutoLayoutView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.RGBA(255, 255, 255, 1)
        setupSubviews()
        setupButtonsInteractions()
        setNeedsUpdateConstraints()
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            
            let topInset = CGFloat(15)
            let leftInset = CGFloat(67)
            let rightInset = CGFloat(67)
            let bottomInset = CGFloat(28)
            
            loadMoreButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // Private
    
    private func setupSubviews() {
        setupLoadMoreButton()
    }
    
    private func setupLoadMoreButton() {
        loadMoreButton.setTitleColor(UIColor.textDarkColor(), forState: .Normal)
        loadMoreButton.titleLabel?.font = UIFont.helveticaFont(.Neue, size: 14)
        loadMoreButton.layer.borderColor = UIColor.RGBA(223, 224, 226, 1).CGColor
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.cornerRadius = 5
        contentView.addSubview(loadMoreButton)
    }
    
    private func setupButtonsInteractions() {
        loadMoreButton.addTarget(self, action: "loadMoreButtonDidTap:", forControlEvents: .TouchUpInside)
    }
}

// MARK: UI Interactions

extension ShotDetailsLoadMoreCollectionViewCell {
    dynamic private func loadMoreButtonDidTap(sender: UIButton) {
        delegate?.shotDetailsLoadMoreCollectionViewCell(self, didTapLoadMoreButton: sender)
    }
}

extension ShotDetailsLoadMoreCollectionViewCell: Reusable {
    class var reuseIdentifier: String {
        return String(ShotDetailsLoadMoreCollectionViewCell)
    }
}
