//
//  ActivityIndicatorSelectableView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum ActivityIndicatorSelectableViewState {
    case Selected, Deselected
}

class ActivityIndicatorSelectableView: UIView {
    
    var selected: Bool {
        get { return button.selected }
        set { button.selected = newValue }
    }
    
    var tapHandler: (() -> Void)?
    
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private let button = UIButton(type: .Custom)
    
    private var didSetConstraints = false
    private var wasSelectedBeforeAnimationStart = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.configureForAutoLayout()
        button.imageView?.backgroundColor = .clearColor()
        button.contentMode = .ScaleAspectFit
        button.setImage(UIImage(), forState: .Disabled)
        button.addTarget(self, action: #selector(buttonDidTap(_:)), forControlEvents: .TouchUpInside)
        addSubview(button)
        
        activityIndicatorView.configureForAutoLayout()
        activityIndicatorView.backgroundColor = .clearColor()
        activityIndicatorView.color = UIColor.grayColor()
        addSubview(activityIndicatorView)
    }
    
    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true
            
            button.autoPinEdgesToSuperviewEdges()
            activityIndicatorView.autoPinEdgesToSuperviewEdges()
        }
        super.updateConstraints()
    }
    
    func setImage(image: UIImage?, forState state: ActivityIndicatorSelectableViewState) {
        button.setImage(image, forState: state.controlState)
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
        button.hidden = true
    }
    
    func stopAnimating() {
        button.hidden = false
        activityIndicatorView.stopAnimating()
    }
}

private extension ActivityIndicatorSelectableView {
    
    dynamic func buttonDidTap(_: UIButton) {
        tapHandler?()
    }
}

private extension ActivityIndicatorSelectableViewState {
    
    var controlState: UIControlState {
        return self == .Selected ? .Selected : .Normal
    }
}
