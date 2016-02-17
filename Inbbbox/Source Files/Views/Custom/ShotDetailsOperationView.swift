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
    private let buttonsSize = CGFloat(28)
    private var didUpdateConstraints = false
    private let defaultBackgroundColor = UIColor.RGBA(246, 248, 248, 1)
    
    private var shotLiked: Bool? {
        didSet {
            // NGRTemp: temp images
            if shotLiked! {
                likeButton.setImage(UIImage(named: "ic-like-details-active"), forState: .Normal)
            } else {
                likeButton.setImage(UIImage(named: "ic-likes"), forState: .Normal)
            }
        }
    }
    
    private var shotInBuckets: Bool? {
        didSet {
            if shotInBuckets! {
                bucketButton.setImage(UIImage(named: "ic-bucket-details-active"), forState: .Normal)
            } else {
                bucketButton.setImage(UIImage(named: "ic-bucket-details"), forState: .Normal)
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
        
        let distanceBetweenButtons = CGFloat(30)
        
        if !didUpdateConstraints {
            
            likeButton.autoPinEdgeToSuperviewEdge(.Top)
            likeButton.autoAlignAxis(.Vertical, toSameAxisOfView: likeButton.superview!, withOffset: -(distanceBetweenButtons/2 + buttonsSize/2))
            likeButton.autoSetDimensionsToSize(CGSize(width: buttonsSize, height: buttonsSize))
            
            bucketButton.autoAlignAxis(.Vertical, toSameAxisOfView: likeButton.superview!, withOffset: distanceBetweenButtons/2 + buttonsSize/2)
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
        likeButton.setImage(UIImage(named: "ic-likes"), forState: .Normal)
        likeButton.contentMode = .ScaleAspectFit
        addSubview(likeButton)
    }
    
    private func setupBucketButton() {
        bucketButton.setImage(UIImage(named: "ic-bucket-details"), forState: .Normal)
        likeButton.contentMode = .ScaleAspectFit
        addSubview(bucketButton)
    }
}
