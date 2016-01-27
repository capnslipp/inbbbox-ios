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
    
    // MARK: Life Cycle
    
    override func loadView() {
        aView = loadViewWithClass(ShotDetailsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func updateViewConstraints() {
        aView?.tableView.setNeedsUpdateConstraints()
        super.updateViewConstraints()
    }
    
    // MARK: Private
    
    private func setupTableView() {
        aView?.tableView.delegate = self
        aView?.tableView.dataSource = self
        aView?.tableView.registerClass(ShotDetailsCell)
    }
    
    private func closeButtonTapped() {
        delegate?.didFinishPresentingDetails(self)
    }
}

extension ShotDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = ShotDetailsHeaderView(image: UIImage(named: "shot-menu")!)
            headerView.delegate = self
            return headerView
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 400
        }
        
        return 0
    }
} 

extension ShotDetailsViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // NGRTodo: Implement me!
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(ShotDetailsCell.self)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

extension ShotDetailsViewController: ShotDetailsTableViewHeaderViewDelegate {
    func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapCloseButton: UIButton) {
        closeButtonTapped()
    }
}
