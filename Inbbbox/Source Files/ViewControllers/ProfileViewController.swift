//
//  ProfileViewController.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import ZFDragableModalTransition
import PromiseKit

class ProfileViewController: TwoLayoutsCollectionViewController {

    private var viewModel: ProfileViewModel!

    private var header: ProfileHeaderView?

    private var indexPathsNeededImageUpdate = [NSIndexPath]()

    var dismissClosure: (() -> Void)?

    var modalTransitionAnimator: ZFModalTransitionAnimator?

    override var containsHeader: Bool {
        return true
    }

    private var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self ||
                self.tabBarController?.presentingViewController is UITabBarController ||
                self.navigationController?.presentingViewController?.presentedViewController ==
                self.navigationController && (self.navigationController != nil)
    }
}

extension ProfileViewController {
    convenience init(user: UserType) {

        guard let accountType = user.accountType where accountType == .Team else {
            self.init(oneColumnLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio,
                      twoColumnsLayoutCellHeightToWidthRatio: SimpleShotCollectionViewCell.heightToWidthRatio)
            viewModel = UserDetailsViewModel(user: user)
            viewModel.delegate = self
            title = viewModel.title
            return
        }

        let team = Team(
            identifier: user.identifier,
            name: user.name ?? "",
            username: user.username,
            avatarURL: user.avatarURL,
            createdAt: NSDate()
        )
        self.init(team: team)
    }

    convenience init(team: TeamType) {

        self.init(oneColumnLayoutCellHeightToWidthRatio: LargeUserCollectionViewCell.heightToWidthRatio,
                  twoColumnsLayoutCellHeightToWidthRatio: SmallUserCollectionViewCell.heightToWidthRatio)

        viewModel = TeamDetailsViewModel(team: team)
        viewModel.delegate = self
        title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else { return }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(SimpleShotCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(SmallUserCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(LargeUserCollectionViewCell.self, type: .Cell)
        collectionView.registerClass(ProfileHeaderView.self, type: .Header)

        do {
            // hides bottom border of navigationBar
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        }

        setupBackButton()

        viewModel.downloadInitialItems()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard viewModel.shouldShowFollowButton else {
            return
        }

        firstly {
            viewModel.isProfileFollowedByMe()
        }.then {
            followed in
            self.header?.userFollowed = followed
        }.always {
            self.header?.stopActivityIndicator()
        }.error {
            error in
            // NGRTodo: provide pop-ups with errors
        }
    }
}

// MARK: Buttons' actions

extension ProfileViewController {

    func didTapFollowButton(_: UIButton) {

        if let userFollowed = header?.userFollowed {

            header?.startActivityIndicator()
            firstly {
                userFollowed ? viewModel.unfollowProfile() : viewModel.followProfile()
            }.then {
                self.header?.userFollowed = !userFollowed
            }.always {
                self.header?.stopActivityIndicator()
            }.error {
                error in
                // NGRTodo: provide pop-ups with errors
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension ProfileViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }

    override func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let viewModel = viewModel as? UserDetailsViewModel {
            let cell = collectionView.dequeueReusableClass(SimpleShotCollectionViewCell.self,
                                                           forIndexPath: indexPath, type: .Cell)
            cell.shotImageView.image = nil
            let cellData = viewModel.shotCollectionViewCellViewData(indexPath)

            indexPathsNeededImageUpdate.append(indexPath)
            lazyLoadImage(cellData.shotImage, forCell: cell, atIndexPath: indexPath)

            cell.gifLabel.hidden = !cellData.animated
            return cell
        }

        if let viewModel = viewModel as? TeamDetailsViewModel {
            let cellData = viewModel.userCollectionViewCellViewData(indexPath)

            indexPathsNeededImageUpdate.append(indexPath)

            if collectionView.collectionViewLayout.isKindOfClass(TwoColumnsCollectionViewFlowLayout) {
                let cell = collectionView.dequeueReusableClass(SmallUserCollectionViewCell.self,
                                                               forIndexPath: indexPath, type: .Cell)
                cell.clearImages()
                cell.avatarView.imageView.loadImageFromURL(cellData.avatarURL)
                cell.nameLabel.text = cellData.name
                cell.numberOfShotsLabel.text = cellData.numberOfShots
                if cellData.shotsImagesURLs?.count > 0 {
                    cell.firstShotImageView.loadImageFromURL(cellData.shotsImagesURLs![0])
                    cell.secondShotImageView.loadImageFromURL(cellData.shotsImagesURLs![1])
                    cell.thirdShotImageView.loadImageFromURL(cellData.shotsImagesURLs![2])
                    cell.fourthShotImageView.loadImageFromURL(cellData.shotsImagesURLs![3])
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableClass(LargeUserCollectionViewCell.self,
                                                               forIndexPath: indexPath, type: .Cell)
                cell.clearImages()
                cell.avatarView.imageView.loadImageFromURL(cellData.avatarURL)
                cell.nameLabel.text = cellData.name
                cell.numberOfShotsLabel.text = cellData.numberOfShots
                if let shotImage = cellData.firstShotImage {

                    let imageLoadingCompletion: UIImage -> Void = { [weak self] image in

                        guard let certainSelf = self
                            where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else { return }

                        cell.shotImageView.image = image
                    }
                    LazyImageProvider.lazyLoadImageFromURLs(
                        (shotImage.teaserURL, isCurrentLayoutOneColumn ? shotImage.normalURL : nil, nil),
                        teaserImageCompletion: imageLoadingCompletion,
                        normalImageCompletion: imageLoadingCompletion
                    )
                }
                return cell
            }
        }

        return UICollectionViewCell()
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if header == nil && kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableClass(ProfileHeaderView.self, forIndexPath: indexPath,
                    type: .Header)
            header?.avatarView.imageView.loadImageFromURL(viewModel.avatarURL)
            header?.button.addTarget(self, action: #selector(didTapFollowButton(_:)), forControlEvents: .TouchUpInside)
            viewModel.shouldShowFollowButton ? header?.startActivityIndicator() : (header?.shouldShowButton = false)
        }

        return header!
    }
}

// MARK: UICollectionViewDelegate

extension ProfileViewController {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let viewModel = viewModel as? UserDetailsViewModel {
            let shotDetailsViewController =
                ShotDetailsViewController(shot: viewModel.shotWithSwappedUser(viewModel.userShots[indexPath.item]))

            modalTransitionAnimator =
                CustomTransitions.pullDownToCloseTransitionForModalViewController(shotDetailsViewController)

            shotDetailsViewController.transitioningDelegate = modalTransitionAnimator
            shotDetailsViewController.modalPresentationStyle = .Custom

            presentViewController(shotDetailsViewController, animated: true, completion: nil)
        }
        if let viewModel = viewModel as? TeamDetailsViewModel {

            let profileViewController = ProfileViewController(user: viewModel.teamMembers[indexPath.item])
            profileViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.itemsCount - 1 {
            viewModel.downloadItemsForNextPage()
        }
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        if let index = indexPathsNeededImageUpdate.indexOf(indexPath) {
            indexPathsNeededImageUpdate.removeAtIndex(index)
        }
    }
}

// MARK: BaseCollectionViewViewModelDelegate

extension ProfileViewController: BaseCollectionViewViewModelDelegate {

    func viewModelDidLoadInitialItems() {
        collectionView?.reloadData()
    }

    func viewModelDidFailToLoadInitialItems(error: ErrorType) {
        collectionView?.reloadData()

        if viewModel.collectionIsEmpty {
            let alert = UIAlertController.generalErrorAlertController()
            presentViewController(alert, animated: true, completion: nil)
            alert.view.tintColor = .pinkColor()
        }
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        collectionView?.insertItemsAtIndexPaths(indexPaths)
    }

    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}

// MARK: Private extension

private extension ProfileViewController {

    func lazyLoadImage(shotImage: ShotImageType, forCell cell: SimpleShotCollectionViewCell,
                       atIndexPath indexPath: NSIndexPath) {
        let imageLoadingCompletion: UIImage -> Void = {
            [weak self] image in

            guard let certainSelf = self where certainSelf.indexPathsNeededImageUpdate.contains(indexPath) else {
                return
            }

            cell.shotImageView.image = image
        }
        LazyImageProvider.lazyLoadImageFromURLs(
            (shotImage.teaserURL, isCurrentLayoutOneColumn ? shotImage.normalURL : nil, nil),
            teaserImageCompletion: imageLoadingCompletion,
            normalImageCompletion: imageLoadingCompletion
        )
    }

    func setupBackButton() {
        if isModal {
            let attributedString = NSMutableAttributedString(
                string: NSLocalizedString("Profile.BackButton",
                comment: "Back button, user details"),
                attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: "ic-back")
            textAttachment.bounds = CGRect(x: 0, y: -3,
                                    width: textAttachment.image!.size.width, height: textAttachment.image!.size.height)
            let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.replaceCharactersInRange(NSRange(location: 0, length: 0),
                                                      withAttributedString: attributedStringWithImage)

            let backButton = UIButton()
            backButton.setAttributedTitle(attributedString, forState: .Normal)
            backButton.addTarget(self, action: #selector(didTapLeftBarButtonItem), forControlEvents: .TouchUpInside)
            backButton.sizeToFit()

            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }

    dynamic func didTapLeftBarButtonItem() {
        dismissClosure?()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
