//
//  ShotDetailsViewController.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 20.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol ShotDetailsViewControllerDelegate: class {
    func didFinishPresentingDetails(sender: ShotDetailsViewController) -> Void
}

class ShotDetailsViewController: UIViewController {
    
    weak var delegate: ShotDetailsViewControllerDelegate?
    var closeButton = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        setupUI()
        setupButtonsInteractions()
    }
    
    // MARK: Button interactions
    @objc private func closeButtonTapped() {
        delegate?.didFinishPresentingDetails(self)
    }
    
    // MARK: UI
    private func setupUI() {
        view.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blur = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(blur)
        blur.autoPinEdgesToSuperviewEdges()
    }

    private func setupButtonsInteractions() {
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        /* NGRTemp: Later, this button will be part of, probably, tableViewHeader.*/
        closeButton = UIButton(forAutoLayout: ())
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        view.addSubview(closeButton)
        
        NSLayoutConstraint(item: closeButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 64.0).active = true
        
        NSLayoutConstraint(item: closeButton,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Right,
            multiplier: 1.0,
            constant: -20.0).active = true
        
        closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
    }
}
