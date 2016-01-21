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
    func didFinishPresentingDetails(sender: ShotDetailsViewController)
}

class ShotDetailsViewController: UIViewController {
    
    weak var delegate: ShotDetailsViewControllerDelegate?
    private weak var aView: ShotDetailsView?
    
    override func loadView() {
        aView = loadViewWithClass(ShotDetailsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        aView?.closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
    }
}

extension ShotDetailsViewController {
    
    @objc private func closeButtonTapped() {
        delegate?.didFinishPresentingDetails(self)
    }
}
