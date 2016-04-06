//
//  UserDetailsViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import ZFDragableModalTransition
import PromiseKit

class UserDetailsViewController: UIViewController {
    
    private var viewModel: UserDetailsViewModel
    
    private var userDetailsView: UserDetailsView {
        return view as! UserDetailsView
    }
    private var header: UserDetailsHeaderView?
    
    var dismissClosure: (() -> Void)?
    
    var modalTransitionAnimator: ZFModalTransitionAnimator?
    
    private var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self || self.tabBarController?.presentingViewController is UITabBarController || self.navigationController?.presentingViewController?.presentedViewController == self.navigationController && (self.navigationController != nil)
    }
    
    // Layout related properties
    var oneColumnLayoutCellHeightToWidthRatio = CGFloat(0.75)
    var twoColumnsLayoutCellHeightToWidthRatio = CGFloat(0.75)
    lazy private var oneColumnLayoutButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(image: UIImage(named: "ic-listview"), style: .Plain, target: self, action: "didTapOneColumnLayoutButton:")
    }()
    lazy private var twoColumnsLayoutButton: UIBarButtonItem = { [unowned self] in
        UIBarButtonItem(image: UIImage(named: "ic-gridview-active"), style: .Plain, target: self, action: "didTapTwoColumnsLayoutButton:")
    }()
    private var isCurrentLayoutOneColumn: Bool {
        get {
            return userDetailsView.collectionView.collectionViewLayout.isKindOfClass(OneColumnCollectionViewFlowLayout)
        }
    }
    
    init(user: UserType) {
        viewModel = UserDetailsViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        title = viewModel.user.name ?? viewModel.user.username
    }
    
    @available(*, unavailable, message="Use init(user:) instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    @available(*, unavailable, message="Use init(user:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UserDetailsView(frame: CGRectZero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.downloadInitialItems()
        
        userDetailsView.collectionView.delegate = self
        userDetailsView.collectionView.dataSource = self
        userDetailsView.collectionView.registerClass(SimpleShotCollectionViewCell.self, type: .Cell)
        userDetailsView.collectionView.registerClass(UserDetailsHeaderView.self, type: .Header)
        
        do { // hides bottom border of navigationBar
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        }
        
        setupBarButtons()
        updateBarButtons(userDetailsView.collectionView.collectionViewLayout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userDetailsView.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.shouldShowFollowButton else { return }
        
        firstly {
            viewModel.isUserFollowedByMe()
        }.then { followed in
            self.header?.userFollowed = followed
        }.always {
            self.header?.stopActivityIndicator()
        }.error { error in
            print(error)
            // NGRTodo: provide pop-ups with errors
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userDetailsView.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: Buttons' actions

extension UserDetailsViewController {
    
    func didTapFollowButton(_: UIButton) {
        
        if let userFollowed = header?.userFollowed {
            
            header?.startActivityIndicator()
            firstly {
                userFollowed ? viewModel.unfollowUser() : viewModel.followUser()
            }.then {
                self.header?.userFollowed = !userFollowed
            }.always {
                self.header?.stopActivityIndicator()
            }.error { error in
                print(error)
                // NGRTodo: provide pop-ups with errors
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension UserDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableClass(SimpleShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.image = nil
        let cellData = viewModel.shotCollectionViewCellViewData(indexPath)
        cell.shotImageView.loadImageFromURL(cellData.imageURL)
        cell.gifLabel.hidden = !cellData.animated
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if header == nil && kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableClass(UserDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)

            header?.avatarView.imageView.loadImageFromURLString(viewModel.user.avatarURL?.absoluteString ?? "")
            header?.button.addTarget(self, action: "didTapFollowButton:", forControlEvents: .TouchUpInside)
            viewModel.shouldShowFollowButton ? header?.startActivityIndicator() : (header?.shouldShowButton = false)
        }
        
        return header!
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount - 1 {
            viewModel.downloadItemsForNextPage()
        }
    }
}

// MARK: UICollectionViewDelegate

extension UserDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let shotDetailsViewController = ShotDetailsViewController(shot: viewModel.shotWithSwappedUser(viewModel.userShots[indexPath.item]))
        
        modalTransitionAnimator = CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)
        
        shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
        shotDetailsViewController.modalPresentationStyle = .Custom
        
        presentViewController(shotDetailsViewController, animated: true, completion: nil)
    }
}

// MARK: BaseCollectionViewViewModelDelegate

extension UserDetailsViewController: BaseCollectionViewViewModelDelegate {
    
    func viewModelDidLoadInitialItems() {
        userDetailsView.collectionView.reloadData()
    }
    
    func viewModelDidFailToLoadInitialItems(error: ErrorType) {
        userDetailsView.collectionView.reloadData()
        
        if viewModel.userShots.isEmpty {
            let alert = UIAlertController.generalErrorAlertController()
            presentViewController(alert, animated: true, completion: nil)
            alert.view.tintColor = .pinkColor()
        }
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        userDetailsView.collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        userDetailsView.collectionView.reloadItemsAtIndexPaths([indexPath])
    }
}

// MARK: Changing layout related methods

private extension UserDetailsViewController {
    
    // MARK: Configuration
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItems = [oneColumnLayoutButton, twoColumnsLayoutButton]
        if isModal {
            let attributedString = NSMutableAttributedString(string: NSLocalizedString(" Back", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: "ic-back")
            textAttachment.bounds = CGRectMake(0, -3, textAttachment.image!.size.width, textAttachment.image!.size.height)
            let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.replaceCharactersInRange(NSMakeRange(0,0), withAttributedString: attributedStringWithImage)

            let backButton = UIButton()
            backButton.setAttributedTitle(attributedString, forState: .Normal)
            backButton.addTarget(self, action: "didTapLeftBarButtonItem", forControlEvents: .TouchUpInside)
            backButton.sizeToFit()
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    func updateBarButtons(layout: UICollectionViewLayout) {
        oneColumnLayoutButton.tintColor = !isCurrentLayoutOneColumn ? UIColor.whiteColor().colorWithAlphaComponent(0.35) : UIColor.whiteColor()
        twoColumnsLayoutButton.tintColor = isCurrentLayoutOneColumn ? UIColor.whiteColor().colorWithAlphaComponent(0.35) : UIColor.whiteColor()
    }
    
    // MARK: Actions:
    
    dynamic func didTapOneColumnLayoutButton(_: UIBarButtonItem) {
        if !isCurrentLayoutOneColumn {
            changeLayout()
        }
    }
    
    dynamic func didTapTwoColumnsLayoutButton(_: UIBarButtonItem) {
        if isCurrentLayoutOneColumn {
            changeLayout()
        }
    }
    
    dynamic func didTapLeftBarButtonItem() {
        dismissClosure?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark: Changing layout
    
    func changeLayout() {
        let collectionView = userDetailsView.collectionView
        
        if collectionView.collectionViewLayout.isKindOfClass(OneColumnCollectionViewFlowLayout) {
            let flowLayout = TwoColumnsCollectionViewFlowLayout()
            flowLayout.itemHeightToWidthRatio = twoColumnsLayoutCellHeightToWidthRatio
            flowLayout.containsHeader = true
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        } else {
            let flowLayout = OneColumnCollectionViewFlowLayout()
            flowLayout.itemHeightToWidthRatio = oneColumnLayoutCellHeightToWidthRatio
            flowLayout.containsHeader = true
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        }
        collectionView.reloadData()
        scrollToTop(collectionView)
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    func scrollToTop(collectionView: UICollectionView) {
        if (collectionView.numberOfItemsInSection(0) > 0) {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
}
