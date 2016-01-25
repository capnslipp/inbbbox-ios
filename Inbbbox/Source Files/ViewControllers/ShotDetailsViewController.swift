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
    let cellID = "ShotDetailsViewCell"
    
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
        aView?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func closeButtonTapped() {
        delegate?.didFinishPresentingDetails(self)
    }
}

extension ShotDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let headerView = ShotDetailsTableViewHeaderView(withImage: UIImage(named: "shot-14")!) //NGRTemp: Here, proper image to be set
        headerView.delegate = self
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 0
        }
        
        return 267
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

extension ShotDetailsViewController: ShotDetailsTableViewHeaderViewDelegate {
    func shotDetailsHeaderView(view: ShotDetailsTableViewHeaderView, didTapCloseButton: UIButton) {
        closeButtonTapped()
    }
}
