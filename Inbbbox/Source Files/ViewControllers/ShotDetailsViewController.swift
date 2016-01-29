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
    //NGRTodo: make this dynamic, based on views heights
    let headerViewHeightNormal: CGFloat = 522
    let headerViewHeightCompact: CGFloat = 100
    var headerViewHeight: CGFloat = 0.0
    let headerView: ShotDetailsHeaderView = {
        let view = ShotDetailsHeaderView(frame: CGRectZero)
        
        // NGRTemp: Until model hooked-up
        let image = UIImage(named: "shot-menu")!
        let shotDescription = "Hey Dribbblers! We are Netguru, a team of 150+ web and mobile software experts. We are just starting with design and want to build something for this awesome community. What’s the plan? Creating and launching Inbbbox - an inbox app for your Dribbble shots. Our developers team will release two native apps (iOS and Android) at the beginning of next year!"
        let title = "Weather Calendar Application"
        let author = "Author link"
        let client = "Client link"
        let info = "app name + date"
        
        view.viewData = ShotDetailsHeaderView.ViewData(description: shotDescription, title: title, author: author, client: client, shotInfo: info, shot: image, avatar: image)
        return view
    }()
    
    // MARK: Life Cycle
    
    override func loadView() {
        aView = loadViewWithClass(ShotDetailsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
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
    
    private func setupHeaderView() {
        headerView.delegate = self
        headerViewHeight = headerViewHeightNormal
    }
    
    private func closeButtonTapped() {
        delegate?.didFinishPresentingDetails(self)
    }
    
    private func changeHeight() {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.aView?.tableView.beginUpdates()
            
            self.headerViewHeight == self.headerViewHeightNormal ? self.headerViewHeightCompact : self.headerViewHeightNormal
            if (self.headerViewHeight == self.headerViewHeightNormal) {
                self.headerViewHeight = self.headerViewHeightCompact
                self.headerView.displayCompactVariant()
            } else {
                self.headerViewHeight = self.headerViewHeightNormal
                self.headerView.displayNormalVariant()
            }
            
            self.aView?.tableView.endUpdates()
        }
    }
}

extension ShotDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerViewHeight
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
