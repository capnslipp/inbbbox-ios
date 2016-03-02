//
//  AnimatableShotImageView.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 02.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout
import KFSwiftImageLoader
import Gifu

class AnimatableShotImageView: AnimatableImageView {
    
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    private var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .followeeShotGrayColor()
        contentMode = .ScaleAspectFit
        
        addSubview(activityIndicatorView)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            didSetupConstraints = true
            
            activityIndicatorView.autoCenterInSuperview()
        }
        
        super.updateConstraints()
    }
    
    func loadAnimatableShotFromUrl(url: NSURL) {
        activityIndicatorView.startAnimating()
        let request = NSURLRequest(URL: url)
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_main_queue(), {
                if let data = data {
                    self.animateWithImageData(data)
                }
                self.activityIndicatorView.stopAnimating()
                // NGRToDo we should show some kind feedback to user if image failed to load
            })
            }.resume()
    }
}

