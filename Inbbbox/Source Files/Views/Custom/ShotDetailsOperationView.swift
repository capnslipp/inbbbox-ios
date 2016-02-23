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
    
    private var didUpdateConstraints = false
    private var buttonSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    private var shotLiked: Bool? {
        didSet {
            if shotLiked! {
                likeButton.setImage(UIImage(named: "ic-like-details-active"), forState: .Normal)
            } else {
                likeButton.setImage(UIImage(named: "ic-like-details"), forState: .Normal)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.RGBA(246, 248, 248, 1)
      
        likeButton.setImage(UIImage(named: "ic-like-details"), forState: .Normal)
        likeButton.contentMode = .ScaleAspectFit
        addSubview(likeButton)

        bucketButton.setImage(UIImage(named: "ic-bucket-details"), forState: .Normal)
        bucketButton.contentMode = .ScaleAspectFit
        addSubview(bucketButton)
    }
    
    @available(*, unavailable, message="Use init(withImage: UIImage) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        let margin = CGFloat(10)
        return CGSize(width: 0, height: buttonSize.height + 2 * margin)
    }
    
    override func updateConstraints() {
        
        if !didUpdateConstraints {
            didUpdateConstraints = true

            let views = [likeButton, bucketButton] as NSArray
            views.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSize: buttonSize.width, insetSpacing: true)
            
            views.forEach {
                $0.autoAlignAxis(.Horizontal, toSameAxisOfView: self)
                $0.autoSetDimension(.Height, toSize: buttonSize.height)
            }
        }
        
        super.updateConstraints()
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
}
