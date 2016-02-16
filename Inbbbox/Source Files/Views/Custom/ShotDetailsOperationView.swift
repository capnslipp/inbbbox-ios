//
//  ShotDetailsOperationView.swift
//  Inbbbox
//
//  Created by Peter Bruz on 12/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ShotDetailsOperationView: UIView {

    let likeButton = UIButton.newAutoLayoutView()
    let bucketButton = UIButton.newAutoLayoutView()
    
    struct ViewData {
        let shotLiked: Bool
        let shotInBuckets: Bool
    }
    
    var viewData: ViewData? {
        didSet {
            shotLiked = viewData!.shotLiked
            shotInBuckets = viewData!.shotInBuckets
        }
    }
    
    
    // Private Properties
    private let buttonsSize = CGFloat(24)
    private var didUpdateConstraints = false
    private let defaultBackgroundColor = UIColor.RGBA(246, 248, 248, 1)
    
    private var shotLiked: Bool? {
        didSet {
            // NGRTemp: temp images
            if shotLiked! {
                likeButton.setBackgroundImage(UIImage(named: "ic-likes-active"), forState: .Normal)
            } else {
                likeButton.setBackgroundImage(UIImage(named: "ic-likes"), forState: .Normal)
            }
        }
    }
    
    private var shotInBuckets: Bool? {
        didSet {
            // NGRTemp: temp images
            if shotInBuckets! {
                bucketButton.setBackgroundImage(UIImage(named: "ic-likes-active"), forState: .Normal)
            } else {
                bucketButton.setBackgroundImage(UIImage(named: "ic-buckets"), forState: .Normal)
            }
        }
    }
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = defaultBackgroundColor
        setupSubviews()
    }
    
    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func updateLikeButton(liked liked: Bool) {
        shotLiked = liked
    }
    
    func isShotLiked() -> Bool {
        return shotLiked!
    }
    
    func isShotInBuckets() -> Bool {
        return shotInBuckets!
    }
    
    // MARK: UI
    
    override func updateConstraints() {
        
        let leftInset = CGFloat(83)
        let distanceBetweenButtons = CGFloat(50)
        
        if !didUpdateConstraints {
            
            likeButton.autoPinEdgeToSuperviewEdge(.Top)
            likeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: leftInset)
            likeButton.autoSetDimensionsToSize(CGSize(width: buttonsSize, height: buttonsSize))
            
            bucketButton.autoPinEdge(.Left, toEdge: .Right, ofView: likeButton, withOffset: distanceBetweenButtons)
            bucketButton.autoPinEdgeToSuperviewEdge(.Top)
            bucketButton.autoSetDimensionsToSize(CGSize(width: buttonsSize, height: buttonsSize))
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        setupLikeButton()
        setupBucketButton()
    }
    
    private func setupLikeButton() {
        // NGRTemp: temp image
        likeButton.setBackgroundImage(UIImage(named: "ic-likes"), forState: .Normal)
        addSubview(likeButton)
    }
    
    private func setupBucketButton() {
        // NGRTemp: temp image
        bucketButton.setBackgroundImage(UIImage(named: "ic-buckets"), forState: .Normal)
        addSubview(bucketButton)
    }
}
