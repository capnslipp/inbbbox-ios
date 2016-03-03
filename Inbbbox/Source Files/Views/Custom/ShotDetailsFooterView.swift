//
//  ShotDetailsFooterView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 02/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

private var cornerRadius: CGFloat {
    return 15
}

private var spaceBetweenBottomEdgeOfFooterAndCollectionView: CGFloat {
    return 20
}

class ShotDetailsFooterView: UICollectionReusableView {
    
    class var minimumRequiredHeight: CGFloat {
        return cornerRadius + spaceBetweenBottomEdgeOfFooterAndCollectionView
    }
    
    var tapHandler: (() -> Void)?
    var shouldShowLoadMoreButton = true {
        willSet(newValue) {
            loadMoreButton.hidden = !newValue
        }
    }
    
    private var didUpdateConstraints = false
    private let loadMoreButton = UIButton.newAutoLayoutView()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private let cornerWrapperView = UIView.newAutoLayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        
        loadMoreButton.addTarget(self, action: "loadMoreButtonDidTap:", forControlEvents: .TouchUpInside)
        loadMoreButton.setTitleColor(UIColor.textDarkColor(), forState: .Normal)
        loadMoreButton.titleLabel?.font = UIFont.helveticaFont(.Neue, size: 14)
        loadMoreButton.layer.borderColor = UIColor.RGBA(223, 224, 226, 1).CGColor
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.cornerRadius = 5
        
        activityIndicatorView.configureForAutoLayout()
        activityIndicatorView.backgroundColor = .clearColor()
        activityIndicatorView.color = .grayColor()
        
        cornerWrapperView.backgroundColor = .RGBA(255, 255, 255, 1)
        cornerWrapperView.addSubview(loadMoreButton)
        cornerWrapperView.addSubview(activityIndicatorView)
        addSubview(cornerWrapperView)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: cornerWrapperView.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            let bottomInset = spaceBetweenBottomEdgeOfFooterAndCollectionView
            cornerWrapperView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            cornerWrapperView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: bottomInset)
            
            let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            loadMoreButton.autoPinEdgesToSuperviewEdgesWithInsets(insets, excludingEdge: .Bottom)
            loadMoreButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: insets.bottom, relation: .LessThanOrEqual)
            
            activityIndicatorView.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateConstraints()
    }
    
    func setTitleForCount(count: UInt) {
        loadMoreButton.setTitle(String.localizedStringWithFormat(NSLocalizedString("Load more comments (%d)", comment: ""), count), forState: .Normal)
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
        loadMoreButton.hidden = true
    }
    
    func stopAnimating() {
        loadMoreButton.hidden = false
        activityIndicatorView.stopAnimating()
    }
    
    func grayOutBackground() {
        cornerWrapperView.backgroundColor = .RGBA(246, 248, 248, 1)
    }
}

private extension ShotDetailsFooterView {
    dynamic func loadMoreButtonDidTap(_: UIButton) {
        tapHandler?()
    }
}

extension ShotDetailsFooterView: Reusable {
    
    class var reuseIdentifier: String {
        return String(ShotDetailsFooterView)
    }
}
